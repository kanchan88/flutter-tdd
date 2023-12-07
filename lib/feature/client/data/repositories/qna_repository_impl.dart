
import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/question_answer_remote_data_source.dart';
import 'package:workoneerweb/feature/client/domain/entities/qna_entity.dart';
import 'package:workoneerweb/feature/client/domain/repositories/qna_repository.dart';

class QNARepositoryImpl extends QNARepository{

  final QNARemoteDataSource qnaRemoteDataSource;

  QNARepositoryImpl({required this.qnaRemoteDataSource});

  @override
  Future<Either<Failure, List<QNAEntity>>> getAllQuestionWithAnswer(String jobId) {
    return getAllQA(jobId);
  }

  @override
  Future<Either<Failure, bool>> postAnswer(String jobId, String qnId, String text) {
    return replyAnswer(jobId, qnId, text);
  }

  @override
  Future<Either<Failure, bool>> postQuestion(String jobId, String text) {
    return addQuestion(jobId, text);
  }



  Future<Either<Failure, List<QNAEntity>>> getAllQA(String jobId) async {

    try {
      List<QNAEntity> allQuesAns = await qnaRemoteDataSource.getAllQuestionWithAnswer(jobId);
      return Right(allQuesAns);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

  Future<Either<Failure, bool>> addQuestion(String jobId, String text) async {

    try {
      bool result = await qnaRemoteDataSource.postQuestion(jobId, text);
      return Right(result);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

  Future<Either<Failure, bool>> replyAnswer(String jobId, String qnId, String text) async {

    try {
      bool result = await qnaRemoteDataSource.postAnswer(jobId, qnId, text);
      return Right(result);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

}