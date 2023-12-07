import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_auth_repo.dart';

class PostClientLoginUseCase extends UseCase<User, Params>{

  ClientAuthRepository clientAuthRepository;

  PostClientLoginUseCase({ required this.clientAuthRepository });

  @override
  Future<Either<Failure, User>> call(Params params) {
    return clientAuthRepository.logIn(params.username, params.pass);
  }

}

class Params extends Equatable {
  final String username;
  final String pass;

  const Params({required this.username, required this.pass});

  @override
  List<Object> get props => [username, pass];
}