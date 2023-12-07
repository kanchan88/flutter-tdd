import 'package:dartz/dartz.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/chat_message_remote_datasource.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_chat_message_repository.dart';
import '/core/error/expection.dart';
import '/core/error/failures.dart';


class ClientChatMessageRepositoryImpl extends ClientChatMessageRepository {

  final ChatMessageRemoteDataSourceImpl remoteDataSource;

  ClientChatMessageRepositoryImpl({required this.remoteDataSource});

  Future<Either<Failure, List<MessageEntity>>> _getAllMsgBetween(String jobId, String traderId) async {
    try {
      List<MessageEntity> msgs = await remoteDataSource.getAllMessagesWithTrader(jobId, traderId);
      return Right(msgs);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllSenders(String jobId) async {
    try {
      List<User> usrs = await remoteDataSource.getSenders(jobId);
      return Right(usrs);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getAllMessagesBetweenWithTrader(String jobId, String traderId) {
    return _getAllMsgBetween(jobId, traderId);
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> sendMessageToTrader(String jobId, String traderId, String userId, String message) async {
    try {
      List<MessageEntity> res = await remoteDataSource.sendMessageOnAuctionToTrader(jobId: jobId, userId: userId, traderId: traderId, message: message);
      return Right(res);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

}