import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/client/data/repositories/bidder_repository_impl.dart';

class GetAllBidderForAuction implements AuctionUseCase<BidderAccountModel, Params> {

  final BidderRepositoryImpl repository;

  GetAllBidderForAuction(this.repository);

  @override
  Future<Either<Failure, List<BidderAccountModel>>> call(Params params) {
    return repository.getAllBiddersForJob(jobId: params.jobId);
  }

}

class Params extends Equatable {
  final String jobId;

  const Params({required this.jobId});

  @override
  List<Object> get props => [jobId];
}