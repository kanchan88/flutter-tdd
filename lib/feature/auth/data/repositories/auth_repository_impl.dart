import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/auth/data/model/user_model.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';

import '/feature/auth/data/datasources/remote/auth_remote_data_source.dart';
import '/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {

  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});


  Future<Either<Failure, UserModel>> parseUserInfo(UserModel user) async {

    try{

      UserModel userEntity = UserModel(
          userId: user.userId,
          email: user.email,
          fullName: user.fullName,
          phone: user.phone,
          status: user.status,
          profilePhoto: user.profilePhoto,
          postCode: user.postCode,
          streetAddress: user.streetAddress,
          country: user.country,
          userType: UserType.trader
      );

      return Right(userEntity);
    } on ServerException {

      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }

    catch(e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, UserModel>> autoLogin() {
    // TODO: implement autoLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> logIn() async {

    try {

      String username = "";
      String password = "";

      final response = await authRemoteDataSource.logInUser(username, password);

      return parseUserInfo(response);

    } catch (e) {

      rethrow;

    }
  }

  @override
  Future<Either<Failure, UserModel>> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> resetPassword() {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> signUp() {
    // TODO: implement signUp
    throw UnimplementedError();
  }


}