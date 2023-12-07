import 'package:flutter/material.dart';
import '/configs/app_colors.dart';

class LoadingData extends StatelessWidget {

  const LoadingData({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
                child: const SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
                child: Text("Fetching the Data from Server!", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w800, fontSize: 18.0),),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.01),
                child: const Text("Please wait a moment.", style: TextStyle(color:Color(0xFFDADADA), fontSize: 16.0),),
              ),

            ],
          ),
        ),
    );
  }
}
