

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';

class AuctionModel extends AuctionEntity {

  AuctionModel({

    required Timestamp? startDate,
    required String? lotNumber,
    required String? description,
    required String? status,
    required List<String>? images,
    required String? mainVideoId,
    required String? selfieVideoId,
    required String? reviewGrade,
    required List<String>? reviewResponse,
    required String client,

  }):super(
      startDate: startDate,
      lotNumber: lotNumber,
      description: description,
      status: status,
      images: images,
      mainVideoId: mainVideoId,
      selfieVideoId: selfieVideoId,
      reviewGrade: reviewGrade,
      reviewResponse: reviewResponse,
      client: client,
  );

  factory AuctionModel.fromJson(Map<String,dynamic> json){

    return AuctionModel(
        status: json['status']??"live",
        description: json['description']??"Start the conversation with a welcome post. Anyone who joins will see.",
        lotNumber: json['lotNumber']??"0",
        startDate: json['startDate']??Timestamp.now(),
        images: json['jobImages'].runtimeType==String?[]:List.from(json['jobImages']),
        mainVideoId: json['video']??"",
        selfieVideoId: json['selfieVideo']??"",
        client: json['userId'],
        reviewGrade: json['reviewGrade'],
        reviewResponse: List.from(json['reviewResponses'])
    );

  }

}