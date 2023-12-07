import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/feature/client/data/model/auction_model.dart';

abstract class TraderAuctionRemoteDataSource {

  Future<List<AuctionModel>> getLiveAuctions();
  Future<List<AuctionModel>> getWonAuctions(String userId);
  Future<AuctionModel> getSingleAuction(String jobId);

}

class TraderAuctionRemoteDataSourceImpl implements TraderAuctionRemoteDataSource {

  @override
  Future<List<AuctionModel>> getLiveAuctions() {
    return getAllJobs();
  }


  @override
  Future<List<AuctionModel>> getWonAuctions(String userId) {
    return getWonJobs(userId);
  }

  @override
  Future<AuctionModel> getSingleAuction(String jobId) {
    return getMySingleAuction(jobId);
  }

  Future<List<AuctionModel>> getAllJobs() async {

    final auctionRef = FirebaseFirestore.instance.collection('auction');

    List<AuctionModel> allJobs =[];

    try {

      var auctions = await auctionRef.get();

      // TODO: filter job by area & service type
      for(var auction in auctions.docs){
          if(auction['status']=='LIVE' || auction['status']=='SOON'){
            AuctionModel singleAuction = AuctionModel.fromJson(auction.data());
            allJobs.add(singleAuction);
          }
      }

      return allJobs;


    } catch (e){
      throw ServerException(e.toString());
    }
  }

  Future<List<AuctionModel>> getWonJobs(String userId) async {

    final auctionRef = FirebaseFirestore.instance.collection('auction');

    List<AuctionModel> allReviewJobs =[];

    try {

      var auctions = await auctionRef.where("winnerId", isEqualTo: userId).get();

      for(var auction in auctions.docs){
        AuctionModel singleAuction = AuctionModel.fromJson(auction.data());
        allReviewJobs.add(singleAuction);
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