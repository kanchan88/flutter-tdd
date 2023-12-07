
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {

  const MessageModel({
    required String id,
    required String text,
    required Timestamp timestamp,
    required bool isSeen
  }):super(text: text, id: id, timestamp: timestamp, isSeen: isSeen);

  factory MessageModel.fromJson(Map<dynamic,dynamic> val){
    return MessageModel(
      id: val['senderId'].toString(),
      text: val['message'].toString(),
      timestamp: val['timestamp'],
      isSeen: val['isSeen']??false,
    );
  }

}