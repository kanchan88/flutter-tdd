import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/auth/data/model/user_model.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/client_auth_remote_data_source.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_auth_repo.dart';


class ClientAuthRepositoryImpl extends ClientAuthRepository {

  final ClientAuthRemoteDataSource authRemoteDataSource;

  ClientAuthRepositoryImpl({required this.authRemoteDataSource});


  Future<User> parseUserInfo(UserModel user) async {

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

      return userEntity;
    } catch(e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Either<Failure, User>> autoLogin() {
    // TODO: implement autoLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> logIn(String username, String password) async {

    try {

      final response = await authRemoteDataSource.logInUser(username, password);

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
  Future<Either<Failure, User>> signUp(User user, String pass) async {
    try {

      final response = await authRemoteDataSource.signUpUser(user, pass);

      return Right(response);

    } on AuthException catch(e) {


      return Left(InvalidDataFailure(textMsg: e.message.toString() ));
    }

    catch (e) {

      return const Left(FetchServerDataFailure(textMsg: 'Server Connection Failed'));

    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(String userId, String password) async {

    try {

      final response = await authRemoteDataSource.changePassClient(userId, password);


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

      final response = await authRemoteDataSource.updateClient(userId, name, phone);


      return Right(response);

    } on AuthException catch(e) {


      return Left(InvalidDataFailure(textMsg: e.message.toString() ));
    }

    catch (e) {

      return const Left(FetchServerDataFailure(textMsg: 'Server Connection Failed'));

    }
  }


}