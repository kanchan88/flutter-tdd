import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/domain/entities/job_sub_category_entity.dart';
import 'package:workoneerweb/feature/client/domain/repositories/job_sub_category_repository.dart';

class GetJobSubCategories extends AuctionUseCase<JobSubCategoryEntity, Params>{

  JobSubCategoryRepository jobSubCategoryRepository;

  GetJobSubCategories({ required this.jobSubCategoryRepository });

  @override
  Future<Either<Failure, List<JobSubCategoryEntity>>> call(Params params) {
    return jobSubCategoryRepository.getAllJobSubCategories(params.catId);
  }

}

class Params extends Equatable {
  final String catId;

  const Params({required this.catId});

  @override
  List<Object> get props => [catId];
}