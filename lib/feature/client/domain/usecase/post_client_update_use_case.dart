import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_auth_repo.dart';

class PostClientUpdateUseCase extends UseCase<User, Params>{

  ClientAuthRepository clientAuthRepository;

  PostClientUpdateUseCase({ required this.clientAuthRepository });

  @override
  Future<Either<Failure, User>> call(Params params) {
    return clientAuthRepository.updateAccount(params.userId, params.name, params.phone);
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