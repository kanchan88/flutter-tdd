import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/data/repositories/auction_repositoy_impl.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';

class GetSingleAuction implements UseCase<AuctionEntity, Params> {

  final AuctionRepositoryImpl repository;

  GetSingleAuction(this.repository);

  @override
  Future<Either<Failure, AuctionEntity>> call(Params params) async {
    return await repository.getSingleAuction(params.jobId);
  }
}

class Params extends Equatable {
  final String jobId;

  const Params({required this.jobId});

  @override
  List<Object> get props => [jobId];
}