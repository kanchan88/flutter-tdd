import 'package:dartz/dartz.dart';

import '../../domain/entities/auction_entity.dart';
import '/core/error/expection.dart';
import '/core/error/failures.dart';
import '/feature/client/data/datasources/remote/auction_remote_data_source.dart';
import '/feature/client/domain/repositories/auction_repository.dart';

class AuctionRepositoryImpl extends AuctionRepository {

  final AuctionRemoteDataSource remoteDataSource;

  AuctionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AuctionEntity>>> getAllMyLiveAuctions(String userId) {
    return _getAuctions(userId);
  }

  @override
  Future<Either<Failure, List<AuctionEntity>>> getAllMyPendingAuctions(String userId) {
    return _getPendingAuctions(userId);
  }

  @override
  Future<Either<Failure, AuctionEntity>> getSingleAuction(String userId) {
    return _getSingleAuctions(userId);
  }

  @override
  Future<Either<Failure, bool>> postAuction(Map auctionInfo) {
    return _postYourAuction(auctionInfo);
  }


  Future<Either<Failure, AuctionEntity>> _getSingleAuctions(String jobId) async {
    try {
      final auction = await remoteDataSource.getSingleAuction(jobId);
      return Right(auction);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

  Future<Either<Failure, List<AuctionEntity>>> _getAuctions(String userId) async {
    try {
      List<AuctionEntity> allAuctions = await remoteDataSource.getLiveAuctions(userId);
      return Right(allAuctions);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

  Future<Either<Failure, List<AuctionEntity>>> _getPendingAuctions(String userId) async {
    try {
      final allAuctions = await remoteDataSource.getPendingAuctions(userId);
      return Right(allAuctions);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

  Future<Either<Failure, bool>> _postYourAuction(Map auctionInfo) async {

    try {
      final result = await remoteDataSource.postSingleAuction(auctionInfo);
      return Right(result);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }


}