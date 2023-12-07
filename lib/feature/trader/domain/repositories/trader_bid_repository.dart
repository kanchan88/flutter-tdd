import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/client/domain/entities/bidder_account_entity.dart';

abstract class TraderBidRepository {

  Future<Either<Failure, List<BidderAccountEntity>>> getAllBiddersForJob({ required String jobId});

  Future<Either<Failure, bool>> placeBid({ required String jobId, required int amount, required BidderAccountEntity bidder});

}