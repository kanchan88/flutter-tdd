import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/domain/entities/qna_entity.dart';
import 'package:workoneerweb/feature/client/domain/repositories/qna_repository.dart';

class GetAllQNAUseCase extends AuctionUseCase<QNAEntity, Params>{

  QNARepository qnaRepository;

  GetAllQNAUseCase({ required this.qnaRepository });

  @override
  Future<Either<Failure, List<QNAEntity>>> call(Params params) {
    return qnaRepository.getAllQuestionWithAnswer(params.jobId);
  }

}

class Params extends Equatable {
  final String jobId;

  const Params({required this.jobId});

  @override
  List<Object> get props => [jobId];
}