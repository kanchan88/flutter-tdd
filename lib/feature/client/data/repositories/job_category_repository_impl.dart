import 'package:dartz/dartz.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/job_category_data_source.dart';
import 'package:workoneerweb/feature/client/domain/entities/job_category_entity.dart';
import 'package:workoneerweb/feature/client/domain/repositories/job_category_repository.dart';
import '/core/error/expection.dart';
import '/core/error/failures.dart';


class JobCategoryRepositoryImpl extends JobCategoryRepository {

  final JobCategoryRemoteDataSource remoteDataSource;

  JobCategoryRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Either<Failure, List<JobCategoryEntity>>> getAllJobCategories() {
    return _getAllJobCats();
  }

  Future<Either<Failure, List<JobCategoryEntity>>> _getAllJobCats() async {
    try {
      List<JobCategoryEntity> bidders = await remoteDataSource.getAllJobCategory();
      return Right(bidders);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

}