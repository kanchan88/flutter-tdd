import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/auth/data/model/user_model.dart';

abstract class AuthRepository {

  Future<Either<Failure, UserModel>> autoLogin();

  Future<Either<Failure, UserModel>> logIn();

  Future<Either<Failure, UserModel>> signUp();

  Future<Either<Failure, UserModel>> resetPassword();

  Future<Either<Failure, UserModel>> logOut();

}