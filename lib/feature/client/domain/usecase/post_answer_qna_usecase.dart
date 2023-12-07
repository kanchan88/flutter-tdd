import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/domain/repositories/qna_repository.dart';

class PostAnswerQNAUseCase extends UseCase<bool, Params>{

  QNARepository qnaRepository;

  PostAnswerQNAUseCase({ required this.qnaRepository });

  @override
  Future<Either<Failure, bool>> call(Params params) {
    return qnaRepository.postAnswer(params.jobId, params.qnId, params.text);
  }

}

class Params extends Equatable {
  final String jobId;
  final String qnId;
  final String text;

  const Params({required this.jobId, required this.text, required this.qnId});

  @override
  List<Object> get props => [jobId, text];
}