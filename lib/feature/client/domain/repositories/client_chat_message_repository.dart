import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';

abstract class ClientChatMessageRepository {

  Future<Either<Failure, List<MessageEntity>>> getAllMessagesBetweenWithTrader(String jobId, String traderId);

  Future<Either<Failure, List<MessageEntity>>> sendMessageToTrader(String jobId, String traderId, String userId, String message);

  Future<Either<Failure, List<User>>> getAllSenders(String jobId);

}