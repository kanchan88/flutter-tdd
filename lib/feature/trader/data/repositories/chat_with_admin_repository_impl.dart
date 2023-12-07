import 'package:dartz/dartz.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/chat_message_remote_datasource.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_chat_message_repository.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/chat_with_admin_remote_data_source.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/chat_with_admin_repository.dart';
import '/core/error/expection.dart';
import '/core/error/failures.dart';


class ChatWithAdminRepositoryImpl extends ChatWithAdminRepository {

  final ChatWithAdminRemoteDataSourceImpl remoteDataSource;

  ChatWithAdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MessageEntity>>> getAllMessagesWithAdmin(String jobId, String traderId) async {
    try {
      List<MessageEntity> msgs = await remoteDataSource.getAllMessagesWithAdmin(jobId, traderId);
      return Right(msgs);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> sendMessageToAdmin(String jobId, String traderId, String message) async {
    try {
      List<MessageEntity> res = await remoteDataSource.sendMessageToAdmin(jobId, traderId, message);
      return Right(res);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

}