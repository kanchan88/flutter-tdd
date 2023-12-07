import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/chat_with_admin_repository.dart';

class PostSendMessageToAdminUseCase extends UseCase<List<MessageEntity>, Params>{

  ChatWithAdminRepository chatWithAdminRepository;

  PostSendMessageToAdminUseCase({ required this.chatWithAdminRepository });

  @override
  Future<Either<Failure, List<MessageEntity>>> call(Params params) {
    return chatWithAdminRepository.sendMessageToAdmin(params.jobId, params.traderId, params.message);
  }

}

class Params extends Equatable {
  final String jobId;
  final String traderId;
  final String message;

  const Params({ required this.traderId, required this.jobId, required this.message});

  @override
  List<Object> get props => [jobId];
}