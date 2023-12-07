
import 'package:flutter/material.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';

class AuthenticationProvider extends ChangeNotifier {

  User? _userModel;

  User? get getUserInfo => _userModel;

  void addUserInfo(User? value) {
    _userModel = value;
    notifyListeners();
  }
}