import 'package:dartz/dartz.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/client/domain/entities/bidder_account_entity.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/trader_bid_remote_datasource.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/trader_bid_repository.dart';
import '/core/error/expection.dart';
import '/core/error/failures.dart';


class TraderBidRepositoryImpl extends TraderBidRepository {

  final TraderBidRemoteDataSource remoteDataSource;

  TraderBidRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BidderAccountModel>>> getAllBiddersForJob({required String jobId}) {
    return _getAllBidder(jobId);
  }

  @override
  Future<Either<Failure, bool>> placeBid({required String jobId, required int amount, required BidderAccountEntity bidder}) {
    return _placeMyBid(jobId, amount, bidder);
  }


  Future<Either<Failure, List<BidderAccountModel>>> _getAllBidder(String jobId) async {
    try {
      List<BidderAccountModel> bidders = await remoteDataSource.getAllBidders(jobId: jobId);
      return Right(bidders);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

  Future<Either<Failure, bool>> _placeMyBid(String jobId, int amount, BidderAccountEntity bidder) async {
    try {
      bool res = await remoteDataSource.placeBid(jobId: jobId, amount: amount, bidder: bidder);
      return Right(res);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

}