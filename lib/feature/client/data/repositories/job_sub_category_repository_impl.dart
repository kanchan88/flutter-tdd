import 'package:dartz/dartz.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/job_sub_category_remote_datasource.dart';
import 'package:workoneerweb/feature/client/domain/entities/job_sub_category_entity.dart';
import 'package:workoneerweb/feature/client/domain/repositories/job_sub_category_repository.dart';
import '/core/error/expection.dart';
import '/core/error/failures.dart';


class JobSubCategoryRepositoryImpl extends JobSubCategoryRepository {

  final JobSubCategoryRemoteDataSource remoteDataSource;

  JobSubCategoryRepositoryImpl({required this.remoteDataSource});



  Future<Either<Failure, List<JobSubCategoryEntity>>> _getAllJobSubCats(String catId) async {
    try {
      List<JobSubCategoryEntity> subCats = await remoteDataSource.getAllJobSubCategory(catId);
      return Right(subCats);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

  @override
  Future<Either<Failure, List<JobSubCategoryEntity>>> getAllJobSubCategories(String id) {
    return _getAllJobSubCats(id);
  }

}