import 'dart:async';

import 'package:workoneerweb/feature/auth/data/model/user_model.dart';

abstract class AuthRemoteDataSource {

  FutureOr<UserModel> signUpUser(UserModel user);

  FutureOr<UserModel> logInUser(String username, String password);

}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource{

  @override
  FutureOr<UserModel> logInUser(String username, String password) async {

    return UserModel.fromJson(const {});
  }

  @override
  FutureOr<UserModel> signUpUser(UserModel user) async {

    return UserModel.fromJson(const {});
  }

}