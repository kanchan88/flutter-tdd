import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';


abstract class TraderAuctionRepository {

  Future<Either<Failure, List<AuctionEntity>>> getAllLiveAuctions();

  Future<Either<Failure, List<AuctionEntity>>> getMyWonAuctions(String userId);

  Future<Either<Failure, AuctionEntity>> getSingleAuction(String userId);

}