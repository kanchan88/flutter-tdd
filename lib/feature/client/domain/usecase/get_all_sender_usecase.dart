import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_chat_message_repository.dart';

class GetAllSenderUseCase implements AuctionUseCase<User, Params> {

  final ClientChatMessageRepository repository;

  GetAllSenderUseCase({required this.repository});

  @override
  Future<Either<Failure, List<User>>> call(Params params) {
    return repository.getAllSenders(params.jobId);
  }

}

class Params extends Equatable {

  final String jobId;

  const Params({required this.jobId});

  @override
  List<Object> get props => [jobId];
}