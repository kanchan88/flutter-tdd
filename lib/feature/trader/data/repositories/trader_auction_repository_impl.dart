


import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/auction_remote_data_source.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/auction_repository.dart';

class TraderAuctionRepositoryImpl extends TraderAuctionRepository {

  TraderAuctionRemoteDataSource traderAuctionRemoteDataSource;

  TraderAuctionRepositoryImpl({required this.traderAuctionRemoteDataSource});


  @override
  Future<Either<Failure, List<AuctionEntity>>> getAllLiveAuctions() {
    return returnFailureOrLiveAuction();
  }

  @override
  Future<Either<Failure, List<AuctionEntity>>> getMyWonAuctions(String userId) {
    return returnFailureOrWonAuction(userId);
  }

  @override
  Future<Either<Failure, AuctionEntity>> getSingleAuction(String userId) {
    // TODO: implement getSingleAuction
    throw UnimplementedError();
  }

  Future<Either<Failure, List<AuctionEntity>>> returnFailureOrLiveAuction() async {

    try {
      final liveAuctions = await traderAuctionRemoteDataSource.getLiveAuctions();
      return Right(liveAuctions);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }

  }

  Future<Either<Failure, List<AuctionEntity>>> returnFailureOrWonAuction(String userId) async {

    try {
      final wonAuctions = await traderAuctionRemoteDataSource.getWonAuctions(userId);
      return Right(wonAuctions);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }

  }


}