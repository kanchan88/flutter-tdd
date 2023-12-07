import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/domain/repositories/auction_repository.dart';

class PostAuctionUseCase extends UseCase<bool, Params>{

  AuctionRepository auctionRepository;

  PostAuctionUseCase({ required this.auctionRepository });

  @override
  Future<Either<Failure, bool>> call(Params params) {
    return auctionRepository.postAuction(params.auctionInfo);
  }
}


class Params extends Equatable {

  final Map auctionInfo;

  const Params({required this.auctionInfo});

  @override
  List<Object> get props => [auctionInfo];
}