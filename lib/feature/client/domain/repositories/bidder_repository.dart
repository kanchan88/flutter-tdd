import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import '../entities/bidder_account_entity.dart';

abstract class BidderRepository {

  Future<Either<Failure, List<BidderAccountEntity>>> getAllBiddersForJob({ required String jobId});

}