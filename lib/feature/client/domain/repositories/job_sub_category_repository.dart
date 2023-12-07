import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/client/domain/entities/job_sub_category_entity.dart';

abstract class JobSubCategoryRepository {

  Future<Either<Failure, List<JobSubCategoryEntity>>> getAllJobSubCategories(String id);

}