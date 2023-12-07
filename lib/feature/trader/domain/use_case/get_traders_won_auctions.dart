import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/auction_repository.dart';

class GetTraderWonAuction implements AuctionUseCase<AuctionEntity, Params> {

  final TraderAuctionRepository repository;

  GetTraderWonAuction({ required this.repository});

  @override
  Future<Either<Failure, List<AuctionEntity>>> call(Params params) async {
    return repository.getMyWonAuctions(params.userId);
  }
}

class Params extends Equatable {
  final String userId;

  const Params({required this.userId});

  @override
  List<Object> get props => [userId];
}
