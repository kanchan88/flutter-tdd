import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workoneerweb/configs/app_colors.dart';

class Error404Screen extends StatelessWidget {
  const Error404Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '404 - PAGE NOT FOUND',
                style: Theme.of(context).textTheme.headline3
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
              child: Text(
                'Oops! The page you are looking for\nis not found',
                style: Theme.of(context).textTheme.bodyText2
              ),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width*0.2,
              child: TextButton(
                onPressed: () {
                  GoRouter.of(context).go("/client");
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0
                        ))),
                child: const Text(
                    "Go Home",
                    style:TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
