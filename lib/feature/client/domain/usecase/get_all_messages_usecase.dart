import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_chat_message_repository.dart';

class GetAllMessagesUseCase implements AuctionUseCase<MessageEntity, Params> {

  final ClientChatMessageRepository repository;

  GetAllMessagesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MessageEntity>>> call(Params params) {
    return repository.getAllMessagesBetweenWithTrader(params.jobId, params.traderId);
  }

}

class Params extends Equatable {
  final String jobId;
  final String traderId;

  const Params({required this.jobId, required this.traderId});

  @override
  List<Object> get props => [jobId];
}