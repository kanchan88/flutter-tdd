import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/auction_repository.dart';

class GetTraderLiveAuction implements NoParamUseCase<AuctionEntity> {

  final TraderAuctionRepository repository;

  GetTraderLiveAuction({ required this.repository});

  @override
  Future<Either<Failure, List<AuctionEntity>>> call() async {
    return repository.getAllLiveAuctions();
  }
}
