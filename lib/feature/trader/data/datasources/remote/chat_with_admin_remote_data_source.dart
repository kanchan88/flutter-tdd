import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/feature/auth/data/model/message_model.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';

abstract class ChatWithAdminRemoteDataSource {

  Future<List<MessageEntity>> getAllMessagesWithAdmin(String jobId, String traderId);

  Future<List<MessageEntity>> sendMessageToAdmin(String jobId, String traderId, String message);

}

class ChatWithAdminRemoteDataSourceImpl implements ChatWithAdminRemoteDataSource {

  final messageRef = FirebaseFirestore.instance.collection("chat");

  @override
  Future<List<MessageEntity>> getAllMessagesWithAdmin(String jobId, String traderId) {
    return _getAllMessagesWithAdmin(jobId, traderId);
  }

  @override
  Future<List<MessageEntity>> sendMessageToAdmin(String jobId, String traderId, String message){
    return sendMessageOnAuctionToAdmin(jobId: jobId, traderId: traderId, message: message);
  }


  Future<List<MessageEntity>>  _getAllMessagesWithAdmin(String jobId, String traderId) async {

    List<MessageEntity> allMessages = [];

    try{

      var msgResponse = await messageRef.doc(jobId).collection('admin-message').doc(traderId).collection('chats').get();
      for(var msg in msgResponse.docs){
        allMessages.add(MessageModel.fromJson(msg.data()));
      }

      return allMessages;

    }
    catch(e){
      throw ServerException(e.toString());
    }


  }


  Future<List<MessageEntity>> sendMessageOnAuctionToAdmin ({
    required String jobId, required String traderId, required String message
  }) async {

    try {

      await messageRef.doc(jobId).collection('admin-message').doc(traderId).collection('chats').add({
        'isSeen':false,
        'message':message,
        'timestamp':Timestamp.now(),
        'senderId':traderId
      });

      List<MessageEntity> allMsg = await _getAllMessagesWithAdmin(jobId, traderId);

      return allMsg;
    }

    catch (e) {
      throw ServerException(e.toString());
    }
  }


}