import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_auth_repo.dart';

class PostClientRegisterUseCase extends UseCase<User, Params>{

  ClientAuthRepository clientAuthRepository;

  PostClientRegisterUseCase({ required this.clientAuthRepository });

  @override
  Future<Either<Failure, User>> call(Params params) {
    return clientAuthRepository.signUp(params.user, params.pass);
  }

}

class Params extends Equatable {
  final User user;
  final String pass;

  const Params({required this.user, required this.pass});

  @override
  List<Object> get props => [user, pass];
}