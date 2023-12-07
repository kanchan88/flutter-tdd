import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/client/domain/entities/qna_entity.dart';


abstract class QNARepository {

  Future<Either<Failure, List<QNAEntity>>> getAllQuestionWithAnswer(String jobId);

  Future<Either<Failure, bool>> postAnswer(String jobId, String qnId, String text);

  Future<Either<Failure, bool>> postQuestion(String jobId, String text);

}