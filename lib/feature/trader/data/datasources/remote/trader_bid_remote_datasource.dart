import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/client/domain/entities/bidder_account_entity.dart';

abstract class TraderBidRemoteDataSource {

  Future<List<BidderAccountModel>> getAllBidders({required String jobId});

  Future<bool> placeBid({required String jobId, required int amount, required BidderAccountEntity bidder});

}

class TraderBidRemoteDataSourceImpl implements TraderBidRemoteDataSource {

  DatabaseReference biddingRef = FirebaseDatabase.instance.ref().child("bids");

  @override
  Future<List<BidderAccountModel>> getAllBidders({required String jobId}) {
    return _getAllBiddersFromFirebase(jobId);
  }

  @override
  Future<bool> placeBid({required String jobId,required int amount, required BidderAccountEntity bidder }) {
    return placeMyBid(jobId, amount, bidder);
  }


  Future<List<BidderAccountModel>>  _getAllBiddersFromFirebase(String jobId) async {

    List<BidderAccountModel> allBidders = [];

    try {

      DataSnapshot myVal = await biddingRef.child(jobId.toString()).child("bids").get();

      if(myVal.exists){
        Map<String, dynamic> biddersMapData = jsonDecode(jsonEncode(myVal.value));

        for(Map<String,dynamic> element in biddersMapData.values){
          allBidders.add(BidderAccountModel.fromJson(element));
        }
      }

      return allBidders;
    }

    on FirebaseException catch (e) {

      throw ServerException(e.message);
    }

    catch(e) {
      throw ServerException(e.toString());
    }

  }


  Future<bool> placeMyBid(String jobId, int bidAmount, BidderAccountEntity bidderAccountModel) async {

    try {
      biddingRef
          .child(jobId)
          .child("bids")
          .child(bidderAccountModel.id)
          .update({
        'user_id':bidderAccountModel.id,
        'username': bidderAccountModel.email,
        'full_name':  bidderAccountModel.fullName,
        'bid_amount': int.parse(bidAmount.toString())
      });
      return true;
    } catch (e) {
      return false;
    }
  }

}