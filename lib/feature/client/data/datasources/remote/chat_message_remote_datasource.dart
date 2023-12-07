import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/feature/auth/data/model/message_model.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/client_info_remote_datasource.dart';

abstract class ChatMessagesRemoteDataSource {

  Future<List<MessageEntity>> getAllMessagesWithTrader(String jobId, String traderId);

  Future<List<User>> getSenders(String jobId);

  Future<List<MessageEntity>> sendMessageToTrader(String jobId, String userId, String traderId, String message);

}

class ChatMessageRemoteDataSourceImpl implements ChatMessagesRemoteDataSource {

  final messageRef = FirebaseFirestore.instance.collection("chat");

  @override
  Future<List<MessageEntity>> getAllMessagesWithTrader(String jobId, String traderId) {
    return _getAllMessagesWithTrader(jobId, traderId);
  }

  @override
  Future<List<User>> getSenders(String jobId){
    return getAllTradesmanWhoMessagedAuction(jobId: jobId);
  }

  @override
  Future<List<MessageEntity>> sendMessageToTrader(String jobId, String userId, String traderId, String message){
    return sendMessageOnAuctionToTrader(jobId: jobId, userId: userId, traderId: traderId, message: message);
  }


  Future<List<MessageEntity>>  _getAllMessagesWithTrader(String jobId, String traderId) async {

    List<MessageEntity> allMessages = [];

    try{

      var msgResponse = await messageRef.doc(jobId).collection('messages').doc(traderId).collection('chats').get();

      for(var msg in msgResponse.docs){
        allMessages.add(MessageModel.fromJson(msg.data()));
      }

      return allMessages;

    }
    catch(e){
      throw ServerException(e.toString());
    }


  }

  Future<List<User>> getAllTradesmanWhoMessagedAuction({ required String jobId }) async {

    List<User> messengers = [];

    List<String> listOfSenderId = [];

    try {

      var senderIds = await messageRef.doc(jobId).collection('messages').get();

      for( var sender in senderIds.docs){
        listOfSenderId.add(sender.id);
      }

      for(String id in listOfSenderId){

        User bidderUserModel = await ClientInfoRemoteDataSourceImpl().getClientInfo(id);
        messengers.add(bidderUserModel);
      }
      return messengers;
    }

    catch (e){
      throw ServerException(e.toString());
    }

  }

  Future<List<MessageEntity>> sendMessageOnAuctionToTrader ({
    required String jobId, required String userId, required String traderId, required String message
  }) async {

    try {

      await messageRef.doc(jobId).set({
        'started':true,
      });

      await messageRef.doc(jobId).collection('messages').doc(userId).set({
        'started':true,
      });

      await messageRef.doc(jobId).collection('messages').doc(traderId).collection('chats').add({
        'isSeen':false,
        'message':message,
        'timestamp':Timestamp.now(),
        'senderId':userId
      });

      List<MessageEntity> allMsg = await _getAllMessagesWithTrader(jobId, traderId);

      return allMsg;
    }

    catch (e) {
      throw ServerException(e.toString());
    }
  }


}