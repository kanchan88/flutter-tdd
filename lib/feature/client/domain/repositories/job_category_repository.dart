import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/client/domain/entities/job_category_entity.dart';

abstract class JobCategoryRepository {

  Future<Either<Failure, List<JobCategoryEntity>>> getAllJobCategories();

}