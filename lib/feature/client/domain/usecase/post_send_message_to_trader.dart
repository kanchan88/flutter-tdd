import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_auth_repo.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_chat_message_repository.dart';

class PostSendMessageToTraderUseCase extends UseCase<List<MessageEntity>, Params>{

  ClientChatMessageRepository clientChatMessageRepository;

  PostSendMessageToTraderUseCase({ required this.clientChatMessageRepository });

  @override
  Future<Either<Failure, List<MessageEntity>>> call(Params params) {
    return clientChatMessageRepository.sendMessageToTrader(params.jobId, params.traderId, params.userId, params.message);
  }

}

class Params extends Equatable {
  final String userId;
  final String jobId;
  final String traderId;
  final String message;

  const Params({required this.userId,  required this.traderId, required this.jobId, required this.message});

  @override
  List<Object> get props => [userId, jobId];
}