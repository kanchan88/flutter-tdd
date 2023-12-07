import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/domain/entities/bidder_account_entity.dart';
import 'package:workoneerweb/feature/trader/data/repositories/trader_bid_repository_impl.dart';

class PlaceBidUseCase implements UseCase<bool, Params> {

  final TraderBidRepositoryImpl repository;

  PlaceBidUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.placeBid(jobId: params.jobId, amount: params.amount, bidder: params.bidder);
  }
}

class Params extends Equatable {
  final String jobId;
  final int amount;
  final BidderAccountEntity bidder;

  const Params({required this.jobId, required this.amount, required this.bidder});

  @override
  List<Object> get props => [jobId];
}