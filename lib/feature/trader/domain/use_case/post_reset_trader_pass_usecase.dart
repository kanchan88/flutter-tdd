import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/trader_auth_repo.dart';

class PostTraderResetPassUseCase extends UseCase<bool, Params>{

  TraderAuthRepository traderAuthRepository;

  PostTraderResetPassUseCase({ required this.traderAuthRepository });

  @override
  Future<Either<Failure, bool>> call(Params params) {
    return traderAuthRepository.resetPassword(params.userId, params.password);
  }

}

class Params extends Equatable {
  final String userId;
  final String password;

  const Params({required this.userId,  required this.password});

  @override
  List<Object> get props => [userId, password];
}