import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workoneerweb/configs/app_colors.dart';

class NoDataFound extends StatelessWidget {

  final String msg;

  const NoDataFound({required this.msg, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
              child: FaIcon(Icons.not_interested, size: MediaQuery.of(context).size.width*0.1, color: AppColors.primaryColor,),
            ),

            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
              child: Text("NO $msg FOUND!", style: const TextStyle(color:Colors.blueGrey, fontSize: 18.0),),
            ),

          ],
        ),
      ),
    );
  }
}