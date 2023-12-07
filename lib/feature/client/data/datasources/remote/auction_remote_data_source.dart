import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/core/methods/publish_to_firebase.dart';
import 'package:workoneerweb/core/utils/upload_video_vimeo.dart';
import 'package:workoneerweb/feature/client/data/model/auction_model.dart';

abstract class AuctionRemoteDataSource {

  Future<List<AuctionModel>> getLiveAuctions(String userId);
  Future<List<AuctionModel>> getPendingAuctions(String userId);
  Future<AuctionModel> getSingleAuction(String auctionId);
  Future<bool> postSingleAuction(Map auctionData);

}

class AuctionRemoteDataSourceImpl implements AuctionRemoteDataSource {


  @override
  Future<List<AuctionModel>> getLiveAuctions(String userId) {
    return getAllMyJobs(userId);
  }


  @override
  Future<List<AuctionModel>> getPendingAuctions(String userId) {
    return getReviewJobs(userId);
  }

  @override
  Future<AuctionModel> getSingleAuction(String jobId) {
    return getMySingleAuction(jobId);
  }

  @override
  Future<bool> postSingleAuction(Map auctionData) {
    return createNewAuction(auctionData);
  }

  // get codes 8 digit
  static String generateUniqueCode() {
    String code = "";
    for (int i = 0; i < 8; i++) {
      code += Random().nextInt(9).toString();
    }
    return code;
  }

  // check if 8 digit code is unique
  Future<String> getUniqueJobId() async {

    String invitationCode = "";

    await Future.doWhile(() async {
      // Generate a new code
      invitationCode = generateUniqueCode();

      // Check if the invitation code exists in the database
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("uniqueJobId").doc(invitationCode).get();

      // If the code doesn't exist, it's unique
      if(snapshot.exists){
        return true;
      } else {
        FirebaseFirestore.instance
            .collection("uniqueJobId").doc(invitationCode).set({
          'used':true
        });
        return false;
      }
    });

    return invitationCode;
  }

  Future<List<AuctionModel>> getAllMyJobs(String userId) async {

    final auctionRef = FirebaseFirestore.instance.collection('auction');

    List<AuctionModel> allJobs =[];

    try {

      var auctions = await auctionRef.where("userId", isEqualTo: userId).get();

      for(var auction in auctions.docs){
        if(auction['status']=="LIVE" || auction['status']=='SOON'){
          AuctionModel singleAuction = AuctionModel.fromJson(auction.data());
          allJobs.add(singleAuction);
        }
      }

      return allJobs;


    } catch (e){
      throw ServerException(e.toString());
    }
  }

  Future<bool> createNewAuction(Map auctionData) async {

    final auctionRef = FirebaseFirestore.instance.collection('auction');

    String uniqueId = await getUniqueJobId();

    List<String> allUploadedImageUrl = [];


    try {

      allUploadedImageUrl = await PublishToFirebase().uploadAllImagesInFirebase(auctionData['jobImages']);


      Map selfVideo = await VimeoVideoRepo().uploadVideoToVimeo(auctionData['selfieVideo']);

      Map jobVideo = await VimeoVideoRepo().uploadVideoToVimeo(auctionData['video']);

      // creating auction
      await auctionRef.doc(uniqueId).set({
        "status": "REVIEW",
        "agent_status": "",
        "propertyId": "",
        "description": "See the bidders and apply for the job. Show your skill get job!",
        "lotNumber": uniqueId,
        "startDate": DateTime.now(),
        "jobImages": allUploadedImageUrl,
        "video": jobVideo['videoId'],
        "selfieVideo": selfVideo['videoId'],
        "reviewGrade": null,
        "reviewResponses": [],
        "address": auctionData['address'],
        "winnerId": "",
        "catId": auctionData['catId'],
        "subCatId": auctionData['subCatId'],
        "userId": auctionData['userId'],
      }, SetOptions(merge: true),);

      return true;

    } catch (e){

      throw ServerException(e.toString());

    }

  }

  Future<List<AuctionModel>> getReviewJobs(String userId) async {

    final auctionRef = FirebaseFirestore.instance.collection('auction');

    List<AuctionModel> allReviewJobs =[];

    try {

      var auctions = await auctionRef.where("userId", isEqualTo: userId).get();

      for(var auction in auctions.docs){
        if(auction['status']=="REVIEW" || auction['status']=='REVIEW_RESPONDED' || auction['status']== 'REVIEW_ACCEPTED'){
          AuctionModel singleAuction = AuctionModel.fromJson(auction.data());
          allReviewJobs.add(singleAuction);
        }
      }
      return allReviewJobs;

    } catch (e){
      throw ServerException(e.toString());
    }
  }


  Future<AuctionModel> getMySingleAuction(String jobId) async {

    AuctionModel myJob;

    final auctionRef = FirebaseFirestore.instance.collection('auction');

    try {
      var auctions = await auctionRef.doc(jobId).get();

      myJob = AuctionModel.fromJson(auctions.data()!);

      return myJob;

    } catch (e){

      throw ServerException(e.toString());
    }

  }



}