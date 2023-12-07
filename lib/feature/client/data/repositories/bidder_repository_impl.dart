import 'package:dartz/dartz.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/client/domain/repositories/bidder_repository.dart';

import '../datasources/remote/bidder_remote_datasource.dart';
import '/core/error/expection.dart';
import '/core/error/failures.dart';


class BidderRepositoryImpl extends BidderRepository {

  final BidderRemoteDataSource remoteDataSource;

  BidderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BidderAccountModel>>> getAllBiddersForJob({required String jobId}) {
    return _getAllBidder(jobId);
  }



  Future<Either<Failure, List<BidderAccountModel>>> _getAllBidder(String jobId) async {
    try {
      List<BidderAccountModel> bidders = await remoteDataSource.getAllBidders(jobId: jobId);
      return Right(bidders);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }
  }

}