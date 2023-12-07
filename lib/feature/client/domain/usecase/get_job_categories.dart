import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/domain/entities/job_category_entity.dart';
import 'package:workoneerweb/feature/client/domain/repositories/job_category_repository.dart';

class GetJobCategories extends NoParamUseCase<JobCategoryEntity>{

  JobCategoryRepository jobCategoryRepository;

  GetJobCategories({ required this.jobCategoryRepository});

  @override
  Future<Either<Failure, List<JobCategoryEntity>>> call() {
    return jobCategoryRepository.getAllJobCategories();
  }

}

