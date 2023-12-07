import 'package:flutter/material.dart';


class ResponsiveUI extends StatelessWidget {

  final Widget mobile;
  final Widget tablet;
  final Widget web;

  const ResponsiveUI({required this.mobile, required this.tablet, required this.web, Key? key}):super(key: key);

  static bool isMobile(BuildContext context){
    return MediaQuery.of(context).size.width < 500;
  }

  static bool isTablet(BuildContext context){
    return MediaQuery.of(context).size.width >=500 && MediaQuery.of(context).size.width < 880 ;
  }

  static bool isWeb(BuildContext context){
    return MediaQuery.of(context).size.width > 880;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if(size.width > 880){
      return web;
    } else if(size.width > 500 && size.width<880){
      return tablet;
    }
    else{
      return mobile;
    }
  }
}

