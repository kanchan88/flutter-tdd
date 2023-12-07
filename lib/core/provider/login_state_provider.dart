
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';

class LoginStateProvider extends ChangeNotifier {


  final SharedPreferences prefs;

  LoginStateProvider(this.prefs);

  String? userId;
  String? email;
  String? fullName;
  UserType? userType;

  String? get getUserId  {
    String? id = prefs.getString('userId');
    return id;
  }

  UserType? get getUserType  {

    String? val = prefs.getString('userType');

    if(val == 'UserType.client'){
      return UserType.client;
    } else {
      return UserType.trader;
    }

  }

  String? get getUserEmail {
    String? email = prefs.getString('userEmail');
    return email;
  }

  String? get getFullName {
    String? name = prefs.getString('userName');
    return name;
  }

  void addUserEmail(String? value)  {

    email = value.toString();
    prefs.setString('userEmail', value.toString());
    notifyListeners();

  }

  void addUserFullName(String? value)  {

    fullName = value.toString();
    prefs.setString('userName', value.toString());
    notifyListeners();

  }

  void addUserId(String? value)  {
    userId = value.toString();
    prefs.setString('userId', value.toString());
    notifyListeners();
  }

  void addUserType(UserType? value)  {
    userType = value!;
    prefs.setString('userType', value.toString());
    notifyListeners();
  }

}