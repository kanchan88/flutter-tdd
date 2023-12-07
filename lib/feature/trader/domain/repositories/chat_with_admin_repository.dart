import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';

abstract class ChatWithAdminRepository {

  Future<Either<Failure, List<MessageEntity>>> getAllMessagesWithAdmin(String jobId, String traderId);

  Future<Either<Failure, List<MessageEntity>>> sendMessageToAdmin(String jobId, String traderId, String message);

}