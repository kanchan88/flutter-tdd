import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/data/repositories/auction_repositoy_impl.dart';

import '../entities/auction_entity.dart';

class GetReviewAuction implements AuctionUseCase<AuctionEntity, Params> {

  final AuctionRepositoryImpl repository;

  GetReviewAuction(this.repository);

  @override
  Future<Either<Failure, List<AuctionEntity>>> call(Params params) async {
    return await repository.getAllMyPendingAuctions(params.userId);
  }
}

class Params extends Equatable {
  final String userId;

  const Params({required this.userId});

  @override
  List<Object> get props => [userId];
}