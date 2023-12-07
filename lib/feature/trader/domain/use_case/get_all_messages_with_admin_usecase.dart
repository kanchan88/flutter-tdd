import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/chat_with_admin_repository.dart';

class GetAllMessagesWithAdminUseCase implements AuctionUseCase<MessageEntity, Params> {

  final ChatWithAdminRepository repository;

  GetAllMessagesWithAdminUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MessageEntity>>> call(Params params) {
    return repository.getAllMessagesWithAdmin(params.jobId, params.traderId);
  }

}

class Params extends Equatable {
  final String jobId;
  final String traderId;

  const Params({required this.jobId, required this.traderId});

  @override
  List<Object> get props => [jobId];
}