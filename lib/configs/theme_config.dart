import 'package:flutter/material.dart';
import 'package:workoneerweb/configs/app_colors.dart';

ThemeData myDefaultTheme = ThemeData(

  fontFamily: 'Montserrat',

  colorScheme: const ColorScheme.light().copyWith(
    primary: AppColors.primaryColor,
    secondary: AppColors.primaryColorOff,
    background: Colors.white,
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: AppColors.primaryColor // button text color
    ),
  ),

  primaryTextTheme: const TextTheme(
    bodySmall: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat', color: Colors.black87),
  ),

  textTheme: const TextTheme(
    headline3: TextStyle(fontSize: 24.0, fontFamily: 'Marcellus', color: Colors.black),
    headline4: TextStyle(fontSize: 20.0, fontFamily: 'Marcellus', color: Colors.black),
    headline5: TextStyle(fontSize: 22.0, fontFamily: 'Montserrat',),
    headline6: TextStyle(fontSize: 16.0, fontFamily: 'MontserratBold',),
    bodyText1: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat',),
    bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat'),
    button: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat'),
  ),
);