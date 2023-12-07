import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/trader_auth_repo.dart';

class PostTraderRegisterUseCase extends UseCase<User, Params>{

  TraderAuthRepository traderAuthRepository;

  PostTraderRegisterUseCase({ required this.traderAuthRepository });

  @override
  Future<Either<Failure, User>> call(Params params) {
    return traderAuthRepository.signUp(params.user, params.pass);
  }

}

class Params extends Equatable {
  final User user;
  final String pass;

  const Params({required this.user, required this.pass});

  @override
  List<Object> get props => [user, pass];
}