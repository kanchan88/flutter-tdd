import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';


abstract class AuctionRepository {

  Future<Either<Failure, List<AuctionEntity>>> getAllMyLiveAuctions(String userId);

  Future<Either<Failure, List<AuctionEntity>>> getAllMyPendingAuctions(String userId);

  Future<Either<Failure, AuctionEntity>> getSingleAuction(String userId);

  Future<Either<Failure, bool>> postAuction(Map auctionInfo);

}