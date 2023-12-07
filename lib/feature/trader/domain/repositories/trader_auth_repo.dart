import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';

abstract class TraderAuthRepository {

  Future<Either<Failure, User>> autoLogin();

  Future<Either<Failure, User>> logIn(String username, String password);

  Future<Either<Failure, User>> signUp(User user, String pass);

  Future<Either<Failure, User>> updateAccount(String userId, String name, String phone);

  Future<Either<Failure, bool>> resetPassword(String userId, String password);

  Future<Either<Failure, User>> logOut();

}