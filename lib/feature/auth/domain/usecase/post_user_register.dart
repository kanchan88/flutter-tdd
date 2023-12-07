import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/data/model/user_model.dart';
import 'package:workoneerweb/feature/auth/domain/repositories/auth_repository.dart';

class PostUserRegister implements UseCase<UserModel, Params> {
  final AuthRepository repository;

  PostUserRegister(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(Params params) async {
    return await repository.signUp();
  }
}

class Params extends Equatable {
  final UserModel user;

  const Params({required this.user});

  @override
  List<Object> get props => [user];
}