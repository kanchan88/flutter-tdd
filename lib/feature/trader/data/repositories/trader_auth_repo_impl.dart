import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/auth/data/model/user_model.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/trader_auth_remote_data_source.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/trader_auth_repo.dart';


class TraderAuthRepositoryImpl extends TraderAuthRepository {

  final TraderAuthRemoteDataSource authRemoteDataSource;

  TraderAuthRepositoryImpl({required this.authRemoteDataSource});


  @override
  Future<Either<Failure, User>> autoLogin() {
    // TODO: implement autoLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> logIn(String username, String password) async {

    try {

      final response = await authRemoteDataSource.logInTrader(username, password);

      return Right(response);

    } catch (e) {

      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));

    }
  }

  @override
  Future<Either<Failure, UserModel>> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> resetPassword(String userId, String password) async {

    try {

      final response = await authRemoteDataSource.changePassTrader(userId, password);


      return Right(response);

    } on AuthException catch(e) {


      return Left(InvalidDataFailure(textMsg: e.message.toString() ));
    }

    catch (e) {

      return const Left(FetchServerDataFailure(textMsg: 'Server Connection Failed'));

    }

  }


  @override
  Future<Either<Failure, User>> signUp(User user, String pass) async {
    try {

      final response = await authRemoteDataSource.signUpTrader(user, pass);


      return Right(response);

    } on AuthException catch(e) {


      return Left(InvalidDataFailure(textMsg: e.message.toString() ));
    }

    catch (e) {

      return const Left(FetchServerDataFailure(textMsg: 'Server Connection Failed'));

    }
  }

  @override
  Future<Either<Failure, User>> updateAccount(String userId, String name, String phone) async {
    try {

      final response = await authRemoteDataSource.updateTrader(userId, name, phone);


      return Right(response);

    } on AuthException catch(e) {


      return Left(InvalidDataFailure(textMsg: e.message.toString() ));
    }

    catch (e) {

      return const Left(FetchServerDataFailure(textMsg: 'Server Connection Failed'));

    }
  }


}