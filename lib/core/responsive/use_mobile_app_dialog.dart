import 'package:flutter/material.dart';
import 'package:workoneerweb/configs/app_assets.dart';

class UseAppDialog extends StatelessWidget {

  const UseAppDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: double.infinity,
        height: MediaQuery.of(context).size.height*0.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                'Ooops! View Not Supported',
                style: Theme.of(context).textTheme.headline6,
              ),

              const SizedBox(height: 10.0,),

              const Text(
                'Please download our app on your device! Or use your desktop to view',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Image.asset(
                    AppAssets.androidIcon,
                    width: MediaQuery.of(context).size.width*0.3,
                  ),

                  Image.asset(
                    AppAssets.iosIcon,
                    width: MediaQuery.of(context).size.width*0.3,
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
