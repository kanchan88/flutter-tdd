import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/feature/auth/data/model/user_model.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/secrets.dart';

abstract class TraderAuthRemoteDataSource {

  FutureOr<User> signUpTrader(User user, String password);

  FutureOr<User> logInTrader(String username, String password);

  FutureOr<User> updateTrader(String userId, String name, String phone);

  FutureOr<bool> changePassTrader(String userId, String password);

}

class TraderAuthRemoteDataSourceImpl extends TraderAuthRemoteDataSource{

  @override
  FutureOr<User> logInTrader(String username, String password) async {
    return loginTraderUsingAPI(username, password);
  }

  @override
  FutureOr<User> signUpTrader(User user, String password) async {

    return registerTraderUsingAPI(user, password);
  }

  @override
  FutureOr<bool> changePassTrader(String userId, String password) async {

    return resetPasswordUsingApi(userId, password);
  }

  @override
  FutureOr<User> updateTrader(String userId, String name, String phone) async {

    return updateTraderUsingAPI(userId, name, phone);
  }

  Future<User> loginTraderUsingAPI(String username, String password) async {

    try{

      var dio = Dio();
      var response = await dio.post(
        "https://workoneer.com/wp-json/workoneer/v1/tradesman_login",
        options: Options(
          headers: {
            "Authorization": basicAuth,
            "Content-Type":"application/json",
          },
        ),

        data: FormData.fromMap({
          "username": username,
          "password":password,
        }),
      );

      if(response.data['data'] != null){
        UserModel currentUser = UserModel.fromAPIJson(response.data['data']);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);

        return currentUser;
      }

      else {
        throw AuthException(response.data['message']);
      }

    }
    catch(e){
      throw ServerException(e.toString());
    }

  }

  Future<User> registerTraderUsingAPI(User userModel, String password) async {

    try{

      var dioRegister = Dio();
      var response = await dioRegister.post(
        "https://workoneer.com/wp-json/workoneer/v1/tradesman_register",
        options: Options(
          headers: {
            "Authorization": basicAuth,
            "Content-Type":"application/json",
          },
        ),

        data: FormData.fromMap({
          "first_name": userModel.fullName,
          "last_name":userModel.fullName,
          "email":userModel.email,
          "password":password,
          "phone":userModel.phone,
          "road_name":'null',
          "street_address":userModel.postCode,
          "country":userModel.country,
          "postal_code":userModel.postCode,
        }),
      );


      if(response.data['success']==true){
        UserModel currentUser = UserModel.fromAPIJson(response.data['user']['data']);
        return currentUser;
      }
      else {
        throw AuthException(response.data['message']);
      }

    }
    catch(e){
      throw ServerException('Server Response Failure');
    }

  }


  Future<User> updateTraderUsingAPI(String userId, String name, String phone) async {

    try{

      var dioUpdate = Dio();
      await dioUpdate.post(
        'https://workoneer.com/wp-json/workoneer/v1/user_profile_update',
        options: Options(
          headers: {
            "Authorization": basicAuth,
            "Content-Type":"application/json",
          },
        ),
        data: FormData.fromMap({
          "user_id": userId,
          "first_name":name,
          "phone":phone,
        }),
      );

      var dioGetUser = Dio();
      var response = await dioGetUser.get(
        "https://workoneer.com/wp-json/workoneer/v1/get_user/$userId",
        options: Options(
          headers: {
            "Authorization": basicAuth,
            "Content-Type":"application/json",
          },
        ),
      );

      UserModel currentUser = UserModel.fromAPIJson(response.data['data']);

      return currentUser;

    }
    catch(e){
      throw ServerException('Server Response Failure');
    }

  }

  Future<bool> resetPasswordUsingApi(String userId, String password) async {

    try{

      var dioUpdate = Dio();
      var res = await dioUpdate.post(
        'https://workoneer.com/wp-json/workoneer/v1/change_password',
        options: Options(
          headers: {
            "Authorization": basicAuth,
            "Content-Type":"application/json",
          },
        ),
        data: FormData.fromMap({
          "user_id": userId,
          "new_password":password,
          "confirm_password":password,
        }),
      );

      if(res.data['success']==true){
        return true;
      } else {
        return false;
      }

    }
    catch(e){
      throw ServerException('Server Response Failure');
    }

  }

}