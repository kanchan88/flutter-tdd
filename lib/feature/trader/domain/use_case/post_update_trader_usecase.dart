import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/trader_auth_repo.dart';

class PostTraderUpdateUseCase extends UseCase<User, Params>{

  TraderAuthRepository traderAuthRepository;

  PostTraderUpdateUseCase({ required this.traderAuthRepository });

  @override
  Future<Either<Failure, User>> call(Params params) {
    return traderAuthRepository.updateAccount(params.userId, params.name, params.phone);
  }

}

class Params extends Equatable {
  final String userId;
  final String name;
  final String phone;

  const Params({required this.userId, required this.name, required this.phone});

  @override
  List<Object> get props => [userId, name, phone];
}