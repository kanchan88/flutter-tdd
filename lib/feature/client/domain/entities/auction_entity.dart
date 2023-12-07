import 'package:cloud_firestore/cloud_firestore.dart';

class AuctionEntity{

  Timestamp? startDate;
  String? lotNumber;
  String? description;
  String? status;
  List<String>? images;
  String? mainVideoId;
  String? selfieVideoId;
  String? reviewGrade;
  List<String>? reviewResponse;
  String? client;
  String? winnerId;

  AuctionEntity({
    this.startDate,
    this.lotNumber,
    this.description,
    this.status,
    this.images,
    this.mainVideoId,
    this.selfieVideoId,
    this.reviewGrade,
    this.reviewResponse,
    this.client,
    this.winnerId
  });

}