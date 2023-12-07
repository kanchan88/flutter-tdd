import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/trader_auth_repo.dart';

class PostTraderLoginUseCase extends UseCase<User, Params>{

  TraderAuthRepository traderAuthRepository;

  PostTraderLoginUseCase({ required this.traderAuthRepository });

  @override
  Future<Either<Failure, User>> call(Params params) {
    return traderAuthRepository.logIn(params.username, params.pass);
  }

}

class Params extends Equatable {
  final String username;
  final String pass;

  const Params({required this.username, required this.pass});

  @override
  List<Object> get props => [username, pass];
}