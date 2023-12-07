import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workoneerweb/configs/app_assets.dart';
import 'package:workoneerweb/configs/app_colors.dart';
import 'package:workoneerweb/core/provider/login_state_provider.dart';
import 'package:workoneerweb/core/responsive/use_mobile_app_dialog.dart';
import 'package:workoneerweb/feature/trader/presentation/bloc/trader_update_bloc.dart';

import '../../../../core/responsive/responsive_ui.dart';
import '../../../auth/presentation/providers/authentication_provider.dart';
import '../common/header_view.dart';

class AccountViewTrader extends StatefulWidget {

  const AccountViewTrader({Key? key}):super(key: key);

  @override
  State<AccountViewTrader> createState() => _AccountViewTraderState();
}

class _AccountViewTraderState extends State<AccountViewTrader> {

  bool editName = false;
  String name = "", phone="";
  bool editPhone = false;

  final _resetPassKey = GlobalKey<FormState>();
  TextEditingController passwordTEC = TextEditingController();

  showResetPassDialog() {

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width*0.4,
              child: BlocConsumer<TraderAccountUpdateBloc, TraderUpdateState>(
                builder: (context, state) {
                  if(state is TraderPassLoading){
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Form(
                        key: _resetPassKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            Text(
                              'Change Password',
                              style: Theme.of(context).textTheme.headline6,
                            ),

                            TextFormField(
                              controller: passwordTEC,
                              validator: (val){
                                if(val!.isEmpty){
                                  return "Password can't be empty";
                                }
                                else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                focusColor: Colors.black,
                                contentPadding: const EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color:Colors.grey, width: 1.0),
                                ),
                              ),
                            ),

                            TextButton(
                              onPressed: (){

                              },
                              child: const CircularProgressIndicator(color: Colors.white,),
                            )

                          ],
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Form(
                      key: _resetPassKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          Text(
                            'Change Password',
                            style: Theme.of(context).textTheme.headline6,
                          ),

                          TextFormField(
                            obscureText: true,
                            controller: passwordTEC,
                            validator: (val){
                              if(val!.isEmpty){
                                return "Password can't be empty";
                              }
                              else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              focusColor: Colors.black,
                              contentPadding: const EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color:Colors.grey, width: 1.0),
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: (){
                              if(_resetPassKey.currentState!.validate()){

                                BlocProvider.of<TraderAccountUpdateBloc>(context).add(
                                    TraderPostResetPassword(
                                        userId: Provider.of<LoginStateProvider>(context, listen: false).getUserId.toString(),
                                        newPass: passwordTEC.text,
                                    )
                                );
                              }
                            },
                            child: const Text('Reset Password', style: TextStyle(color: Colors.white),),
                          )

                        ],
                      ),
                    ),
                  );
                },
                listener: (context, state){
                  if(state is TraderPassResetSuccess){
                    if(state.status==true){
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: 'Reset Pass Successfull');
                    } else {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: 'Reset Pass Failed');
                    }
                  }
                },
              ),
            ),
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveUI.isMobile(context)? const UseAppDialog() :Scaffold(
      body: ListView(
        children: [

          const HeaderTrader(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.07, vertical: MediaQuery.of(context).size.height*0.05 ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                onTap:(){
                  setState(() {
                    editPhone = false;
                    editName = false;
                  });
                },
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "MY ACCOUNT",
                                    style: Theme.of(context).textTheme.headline3,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Manage your and edit your account",
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ],
                            ),


                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),

                    Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          BlocConsumer<TraderAccountUpdateBloc, TraderUpdateState>(
                              listener: (context, state){
                                if(state is TraderUpdateLoading){
                                  Fluttertoast.showToast(msg: 'Updating....');
                                }
                                else if (state is TraderUpdateFailed){
                                  Fluttertoast.showToast(msg: 'Update Failed');
                                }
                                else if(state is TraderUpdateSuccess){
                                  Fluttertoast.showToast(msg: 'Updated!');
                                }
                              },
                              builder: (context, state){
                                if(state is TraderUpdateLoading){
                                  return Expanded(
                                    flex: 4,
                                    child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        child: Column(
                                          children: [

                                            const SizedBox(
                                              height: 10.0,
                                              child: LinearProgressIndicator()
                                            ),

                                            Container(
                                              color: Colors.white,
                                              height: MediaQuery.of(context).size.height*0.62,
                                              child: Padding(
                                                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Profile Details", style: Theme.of(context).textTheme.headline6,),
                                                    SizedBox(
                                                      height: MediaQuery.of(context).size.height*0.01,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [

                                                        // TODO: shared prefs photo
                                                        CircleAvatar(
                                                          radius: MediaQuery.of(context).size.width*0.04,
                                                          backgroundImage: NetworkImage(
                                                            ''
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width*0.02,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap:(){
                                                                setState(() {
                                                                  editName = true;
                                                                });
                                                              },
                                                              child: editName ?

                                                              SizedBox(

                                                                width: 200,
                                                                child: TextFormField(
                                                                  initialValue: Provider.of<LoginStateProvider>(context, listen: false).getFullName.toString(),
                                                                  onChanged: (val){
                                                                    setState(() {
                                                                      name = val;
                                                                    });
                                                                  },

                                                                  decoration: InputDecoration(
                                                                      isDense: true,
                                                                      focusColor: Colors.black,
                                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:6.0),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(20),
                                                                        borderSide: const BorderSide(
                                                                            color:Colors.grey, width: 1.0),
                                                                      ),
                                                                      suffix:IconButton(
                                                                        onPressed: (){

                                                                          BlocProvider.of<TraderAccountUpdateBloc>(context).add(
                                                                              TraderPostUpdate(
                                                                              userId: Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.userId,
                                                                              name: name.isEmpty?Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.fullName:name,
                                                                              phone: phone.isEmpty?Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.phone:phone
                                                                            )
                                                                          );


                                                                          setState(() {
                                                                            editName = false;
                                                                          });
                                                                        },
                                                                        icon: const Icon(Icons.done, color: Colors.black,size: 18,),
                                                                      )
                                                                  ),
                                                                ),
                                                              ):

                                                              Text(
                                                                Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.fullName,
                                                                style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 18.0),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.of(context).size.height*0.01,
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width*0.3,
                                                              child: Row(
                                                                children: [

                                                                  Expanded(
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.grey),
                                                                        borderRadius: BorderRadius.circular(20.0),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(
                                                                            MediaQuery.of(context).size.width*0.005
                                                                        ),
                                                                        child: Row(
                                                                          children: const [
                                                                            Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                                child: FaIcon(
                                                                                  FontAwesomeIcons.cloudArrowUp,
                                                                                  size: 14.0,
                                                                                )
                                                                            ),
                                                                            Text("Upload", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),)
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(width: 10.0,),

                                                                  Expanded(
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.grey),
                                                                        borderRadius: BorderRadius.circular(20.0),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(
                                                                            MediaQuery.of(context).size.width*0.005
                                                                        ),
                                                                        child: Row(
                                                                          children: const [
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                              child: Icon(
                                                                                Icons.delete,
                                                                                size: 16.0,
                                                                              ),
                                                                            ),
                                                                            Text("Remove", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),)
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: MediaQuery.of(context).size.height*0.03,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [

                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [

                                                              Text("Email", style: Theme.of(context).textTheme.headline6,),
                                                              SizedBox(
                                                                height: MediaQuery.of(context).size.height*0.01,
                                                              ),

                                                              Container(
                                                                width:MediaQuery.of(context).size.width*0.25,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(color: Colors.grey),
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(
                                                                      MediaQuery.of(context).size.width*0.005
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                                                    child: Text(
                                                                      Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.email,
                                                                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        const SizedBox(width: 10.0,),

                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [

                                                              Text("Phone", style: Theme.of(context).textTheme.headline6,),
                                                              SizedBox(
                                                                height: MediaQuery.of(context).size.height*0.01,
                                                              ),

                                                              editPhone? TextFormField(
                                                                initialValue: Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.phone,
                                                                onChanged: (val){
                                                                  setState(() {
                                                                    phone = val;
                                                                  });
                                                                },

                                                                decoration: InputDecoration(
                                                                    isDense: true,
                                                                    focusColor: Colors.black,
                                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:6.0),
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(20),
                                                                      borderSide: const BorderSide(
                                                                          color:Colors.grey, width: 1.0),
                                                                    ),
                                                                    suffix:IconButton(
                                                                      onPressed: (){

                                                                        BlocProvider.of<TraderAccountUpdateBloc>(context).add(
                                                                            TraderPostUpdate(
                                                                                userId: Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.userId,
                                                                                name: name.isEmpty?Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.fullName:name,
                                                                                phone: phone.isEmpty?Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.phone:phone
                                                                            )
                                                                        );

                                                                        setState(() {
                                                                          editPhone = false;
                                                                        });
                                                                      },
                                                                      icon: const Icon(Icons.done, color: Colors.black,size: 18,),
                                                                    )
                                                                ),
                                                              )
                                                                  :GestureDetector(
                                                                onTap: (){
                                                                  setState(() {
                                                                    editPhone = true;
                                                                  });
                                                                },
                                                                child: Container(
                                                                  width:MediaQuery.of(context).size.width*0.25,
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(color: Colors.grey),
                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: EdgeInsets.all(
                                                                        MediaQuery.of(context).size.width*0.005
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                                                      child: Text(
                                                                        Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.phone,
                                                                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: MediaQuery.of(context).size.height*0.03,
                                                    ),

                                                    Text("Linked Accounts", style: Theme.of(context).textTheme.headline6,),

                                                    SizedBox(
                                                      height: MediaQuery.of(context).size.height*0.01,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,

                                                      children: [
                                                        TextButton(
                                                            onPressed: () {},
                                                            style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                                shape: MaterialStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                        side: const BorderSide(color: Colors.grey),
                                                                        borderRadius: BorderRadius.circular(30))),
                                                                padding: MaterialStateProperty.all(
                                                                    const EdgeInsets.symmetric(
                                                                        vertical: 15,horizontal: 25.0
                                                                    ))),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Image.asset(AppAssets.googleIcn, height: 16),
                                                                const SizedBox(width: 10),
                                                                const Text(
                                                                  "Google Login",
                                                                  style:TextStyle(
                                                                      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
                                                                ),
                                                              ],
                                                            )),
                                                        const SizedBox(width: 10),
                                                        TextButton(
                                                            onPressed: () {},
                                                            style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                                shape: MaterialStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                        side: const BorderSide(color: Colors.grey),
                                                                        borderRadius: BorderRadius.circular(30))),
                                                                padding: MaterialStateProperty.all(
                                                                    const EdgeInsets.symmetric(
                                                                        vertical: 15, horizontal: 25.0
                                                                    ))),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Image.asset(AppAssets.facebookIcn, height: 16),
                                                                const SizedBox(width: 10),
                                                                const Text(
                                                                    "Facebook Login",
                                                                    style:TextStyle(
                                                                        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
                                                              ],
                                                            )),
                                                      ],)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height*0.03,
                                            ),

                                            Row(
                                              children: [

                                                Expanded(
                                                  child: Container(
                                                      color: Colors.white,
                                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03, vertical: MediaQuery.of(context).size.width*0.02),
                                                      height: MediaQuery.of(context).size.height*0.34,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Change Password", style: Theme.of(context).textTheme.headline6,),

                                                          const SizedBox(
                                                            height: 4,
                                                          ),

                                                          const Text("You can permanently delete or temporarily freeze your account", style: TextStyle(fontSize: 14.0),),

                                                          const SizedBox(
                                                            height: 4,
                                                          ),

                                                          TextButton(
                                                            onPressed: () {
                                                              showResetPassDialog();
                                                            },
                                                            style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all(AppColors.primaryColorOff),
                                                                shape: MaterialStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(30))),
                                                                padding: MaterialStateProperty.all(
                                                                    const EdgeInsets.symmetric(
                                                                        vertical: 15, horizontal: 25.0
                                                                    ))),
                                                            child: const Text(
                                                                "Change Password",
                                                                style:TextStyle(
                                                                    fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryColor)),

                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                ),
                                                SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                                                Expanded(
                                                  child: Container(
                                                      color: Colors.white,
                                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03, vertical: MediaQuery.of(context).size.width*0.02),
                                                      height: MediaQuery.of(context).size.height*0.34,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Close Accounts", style: Theme.of(context).textTheme.headline6,),

                                                          const SizedBox(
                                                            height: 4,
                                                          ),

                                                          const Text("You can permanently delete or temporarily freeze your account", style: TextStyle(fontSize: 14.0),),

                                                          const SizedBox(
                                                            height: 4,
                                                          ),

                                                          TextButton(
                                                            onPressed: () {},
                                                            style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                                shape: MaterialStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                        side: const BorderSide(color: AppColors.primaryColor),
                                                                        borderRadius: BorderRadius.circular(30))),
                                                                padding: MaterialStateProperty.all(
                                                                    const EdgeInsets.symmetric(
                                                                        vertical: 15, horizontal: 25.0
                                                                    ))),
                                                            child: const Text(
                                                                "Close Account",
                                                                style:TextStyle(
                                                                    fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryColor)),

                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  );
                                }
                                return Expanded(
                                  flex: 4,
                                  child: SizedBox(
                                      height: MediaQuery.of(context).size.height,
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            height: MediaQuery.of(context).size.height*0.62,
                                            child: Padding(
                                              padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Profile Details", style: Theme.of(context).textTheme.headline6,),
                                                  SizedBox(
                                                    height: MediaQuery.of(context).size.height*0.01,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: MediaQuery.of(context).size.width*0.04,
                                                        backgroundImage: NetworkImage(
                                                          Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.profilePhoto,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width*0.02,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap:(){
                                                              setState(() {
                                                                editName = true;
                                                              });
                                                            },
                                                            child: editName ?

                                                            SizedBox(

                                                              width: 200,
                                                              child: TextFormField(
                                                                initialValue: Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.fullName,
                                                                onChanged: (val){
                                                                  setState(() {
                                                                    name = val;
                                                                  });
                                                                },

                                                                decoration: InputDecoration(
                                                                    isDense: true,
                                                                    focusColor: Colors.black,
                                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:6.0),
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(20),
                                                                      borderSide: const BorderSide(
                                                                          color:Colors.grey, width: 1.0),
                                                                    ),
                                                                    suffix:IconButton(
                                                                      onPressed: (){

                                                                        BlocProvider.of<TraderAccountUpdateBloc>(context).add(
                                                                            TraderPostUpdate(
                                                                                userId: Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.userId,
                                                                                name: name.isEmpty?Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.fullName:name,
                                                                                phone: phone.isEmpty?Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.phone:phone
                                                                            )
                                                                        );

                                                                        setState(() {
                                                                          editName = false;
                                                                        });
                                                                      },
                                                                      icon: const Icon(Icons.done, color: Colors.black,size: 18,),
                                                                    )
                                                                ),
                                                              ),
                                                            ):

                                                            Text(
                                                              Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.fullName,
                                                              style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 18.0),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: MediaQuery.of(context).size.height*0.01,
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(context).size.width*0.3,
                                                            child: Row(
                                                              children: [

                                                                Expanded(
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(color: Colors.grey),
                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: EdgeInsets.all(
                                                                          MediaQuery.of(context).size.width*0.005
                                                                      ),
                                                                      child: Row(
                                                                        children: const [
                                                                          Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                              child: FaIcon(
                                                                                FontAwesomeIcons.cloudArrowUp,
                                                                                size: 14.0,
                                                                              )
                                                                          ),
                                                                          Text("Upload", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                                const SizedBox(width: 10.0,),

                                                                Expanded(
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(color: Colors.grey),
                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: EdgeInsets.all(
                                                                          MediaQuery.of(context).size.width*0.005
                                                                      ),
                                                                      child: Row(
                                                                        children: const [
                                                                          Padding(
                                                                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child: Icon(
                                                                              Icons.delete,
                                                                              size: 16.0,
                                                                            ),
                                                                          ),
                                                                          Text("Remove", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: MediaQuery.of(context).size.height*0.03,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [

                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [

                                                            Text("Email", style: Theme.of(context).textTheme.headline6,),
                                                            SizedBox(
                                                              height: MediaQuery.of(context).size.height*0.01,
                                                            ),

                                                            Container(
                                                              width:MediaQuery.of(context).size.width*0.25,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(color: Colors.grey),
                                                                borderRadius: BorderRadius.circular(20.0),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets.all(
                                                                    MediaQuery.of(context).size.width*0.005
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                                                  child: Text(
                                                                    Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.email,
                                                                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      const SizedBox(width: 10.0,),

                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [

                                                            Text("Phone", style: Theme.of(context).textTheme.headline6,),
                                                            SizedBox(
                                                              height: MediaQuery.of(context).size.height*0.01,
                                                            ),

                                                            editPhone? TextFormField(
                                                              initialValue: Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.phone,
                                                              onChanged: (val){
                                                                setState(() {
                                                                  phone = val;
                                                                });
                                                              },

                                                              decoration: InputDecoration(
                                                                  isDense: true,
                                                                  focusColor: Colors.black,
                                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:6.0),
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    borderSide: const BorderSide(
                                                                        color:Colors.grey, width: 1.0),
                                                                  ),
                                                                  suffix:IconButton(
                                                                    onPressed: (){
                                                                      BlocProvider.of<TraderAccountUpdateBloc>(context).add(
                                                                          TraderPostUpdate(
                                                                              userId: Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.userId,
                                                                              name: name.isEmpty?Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.fullName:name,
                                                                              phone: phone.isEmpty?Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.phone:phone
                                                                          )
                                                                      );

                                                                      setState(() {
                                                                        editPhone = false;
                                                                      });
                                                                    },
                                                                    icon: const Icon(Icons.done, color: Colors.black,size: 18,),
                                                                  )
                                                              ),
                                                            )
                                                                :GestureDetector(
                                                              onTap: (){
                                                                setState(() {
                                                                  editPhone = true;
                                                                });
                                                              },
                                                              child: Container(
                                                                width:MediaQuery.of(context).size.width*0.25,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(color: Colors.grey),
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(
                                                                      MediaQuery.of(context).size.width*0.005
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                                                    child: Text(
                                                                      Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.phone,
                                                                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(
                                                    height: MediaQuery.of(context).size.height*0.03,
                                                  ),

                                                  Text("Linked Accounts", style: Theme.of(context).textTheme.headline6,),

                                                  SizedBox(
                                                    height: MediaQuery.of(context).size.height*0.01,
                                                  ),

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,

                                                    children: [
                                                      TextButton(
                                                          onPressed: () {},
                                                          style: ButtonStyle(
                                                              backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                              shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                      side: const BorderSide(color: Colors.grey),
                                                                      borderRadius: BorderRadius.circular(30))),
                                                              padding: MaterialStateProperty.all(
                                                                  const EdgeInsets.symmetric(
                                                                      vertical: 15,horizontal: 25.0
                                                                  ))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Image.asset(AppAssets.googleIcn, height: 16),
                                                              const SizedBox(width: 10),
                                                              const Text(
                                                                "Google Login",
                                                                style:TextStyle(
                                                                    fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
                                                              ),
                                                            ],
                                                          )),
                                                      const SizedBox(width: 10),
                                                      TextButton(
                                                          onPressed: () {},
                                                          style: ButtonStyle(
                                                              backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                              shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                      side: const BorderSide(color: Colors.grey),
                                                                      borderRadius: BorderRadius.circular(30))),
                                                              padding: MaterialStateProperty.all(
                                                                  const EdgeInsets.symmetric(
                                                                      vertical: 15, horizontal: 25.0
                                                                  ))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Image.asset(AppAssets.facebookIcn, height: 16),
                                                              const SizedBox(width: 10),
                                                              const Text(
                                                                  "Facebook Login",
                                                                  style:TextStyle(
                                                                      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
                                                            ],
                                                          )),
                                                    ],)
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height*0.03,
                                          ),

                                          Row(
                                            children: [

                                              Expanded(
                                                child: Container(
                                                    color: Colors.white,
                                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03, vertical: MediaQuery.of(context).size.width*0.02),
                                                    height: MediaQuery.of(context).size.height*0.34,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Change Password", style: Theme.of(context).textTheme.headline6,),

                                                        const SizedBox(
                                                          height: 4,
                                                        ),

                                                        const Text("You can permanently delete or temporarily freeze your account", style: TextStyle(fontSize: 14.0),),

                                                        const SizedBox(
                                                          height: 4,
                                                        ),

                                                        TextButton(
                                                          onPressed: () {
                                                            showResetPassDialog();
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor: MaterialStateProperty.all(AppColors.primaryColorOff),
                                                              shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(30))),
                                                              padding: MaterialStateProperty.all(
                                                                  const EdgeInsets.symmetric(
                                                                      vertical: 15, horizontal: 25.0
                                                                  ))),
                                                          child: const Text(
                                                              "Change Password",
                                                              style:TextStyle(
                                                                  fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryColor)),

                                                        ),
                                                      ],
                                                    )
                                                ),
                                              ),
                                              SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                                              Expanded(
                                                child: Container(
                                                    color: Colors.white,
                                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03, vertical: MediaQuery.of(context).size.width*0.02),
                                                    height: MediaQuery.of(context).size.height*0.34,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Close Accounts", style: Theme.of(context).textTheme.headline6,),

                                                        const SizedBox(
                                                          height: 4,
                                                        ),

                                                        const Text("You can permanently delete or temporarily freeze your account", style: TextStyle(fontSize: 14.0),),

                                                        const SizedBox(
                                                          height: 4,
                                                        ),

                                                        TextButton(
                                                          onPressed: () {},
                                                          style: ButtonStyle(
                                                              backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                              shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                      side: const BorderSide(color: AppColors.primaryColor),
                                                                      borderRadius: BorderRadius.circular(30))),
                                                              padding: MaterialStateProperty.all(
                                                                  const EdgeInsets.symmetric(
                                                                      vertical: 15, horizontal: 25.0
                                                                  ))),
                                                          child: const Text(
                                                              "Close Account",
                                                              style:TextStyle(
                                                                  fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryColor)),

                                                        ),
                                                      ],
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                );
                              },
                          ),

                          SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                          Expanded(
                            flex: 2,
                            child: Container(
                                height: MediaQuery.of(context).size.height*0.2,
                                decoration: const BoxDecoration(color: AppColors.primaryColor),
                                child: Padding(
                                  padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Balance", style: TextStyle(fontSize: 16.0, color: Colors.white),),
                                          const SizedBox(height: 8.0,),
                                          Text("\$80", style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white, fontSize: 18.0),)
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Credit", style: TextStyle(fontSize: 16.0, color: Colors.white),),
                                          const SizedBox(height: 8.0,),
                                          Text("\$10", style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white, fontSize: 18.0),)
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
