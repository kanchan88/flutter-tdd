import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_auth_repo.dart';

class PostClientResetPassUseCase extends UseCase<bool, Params>{

  ClientAuthRepository clientAuthRepository;

  PostClientResetPassUseCase({ required this.clientAuthRepository });

  @override
  Future<Either<Failure, bool>> call(Params params) {
    return clientAuthRepository.resetPassword(params.userId, params.password);
  }

}

class Params extends Equatable {
  final String userId;
  final String password;

  const Params({required this.userId,  required this.password});

  @override
  List<Object> get props => [userId, password];
}