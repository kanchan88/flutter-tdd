
import '../../domain/entities/bidder_account_entity.dart';

class BidderAccountModel extends BidderAccountEntity {

  BidderAccountModel({
    required String id,
    required String fullName,
    required int bidAmount,
    required String date,
    required String email,
  }):super(
    id:id,
    fullName: fullName,
    email: email,
    date: date,
    bidAmount: bidAmount
  );

  factory BidderAccountModel.fromJson(Map<String,dynamic> val){
    return BidderAccountModel(
        id: val['user_id'].toString(),
        email: val['user_email']??"",
        fullName: val['username']??"",
        bidAmount: val['bid_amount']??0,
        date: val['date']??""
    );
  }


}