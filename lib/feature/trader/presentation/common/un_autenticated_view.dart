import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workoneerweb/configs/app_colors.dart';

class UnAuthenticatedView extends StatelessWidget {

  final String user;

  const UnAuthenticatedView({required this.user, Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(height: MediaQuery.of(context).size.height*0.1,),

          Icon(Icons.not_accessible, color: AppColors.primaryColor, size: MediaQuery.of(context).size.height*0.1,),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Un-authenticated View!", style: Theme.of(context).textTheme.headline4,),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Text("You should be $user to view this page", style: Theme.of(context).textTheme.headline6,),
          ),

          user=="trader"?
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextButton(
              onPressed: (){
                GoRouter.of(context).push('/trader-login');
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Login as Trader", style: TextStyle(color: Colors.white),),
              ),
            ),
          ):
          TextButton(
            onPressed: (){
              GoRouter.of(context).push('/client-login');
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Login as Client", style: TextStyle(color: Colors.white),),
            ),
          )

        ],
      ),
    );
  }
}
