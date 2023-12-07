import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workoneerweb/core/responsive/use_mobile_app_dialog.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/auth/presentation/providers/authentication_provider.dart';
import 'package:workoneerweb/feature/trader/presentation/bloc/trader_auth_bloc.dart';

import '../../../../../core/provider/login_state_provider.dart';
import '/configs/app_assets.dart';
import '/configs/app_colors.dart';
import '/core/responsive/responsive_ui.dart';
import '/core/utils/validators.dart';
import '/core/widgets/progress_dialog.dart';

class LoginScreenTrader extends StatefulWidget {

  const LoginScreenTrader({Key? key}) : super(key: key);

  @override
  State<LoginScreenTrader> createState() => _LoginScreenTraderState();
}

class _LoginScreenTraderState extends State<LoginScreenTrader> {

  final emailTFC = TextEditingController();

  final passwordTFC = TextEditingController();

  final FocusNode passwordFN = FocusNode();

  final FocusNode emailFN = FocusNode();

  final _loginKey = GlobalKey<FormState>();

  final _resetFormKey = GlobalKey<FormState>();

  bool validateEmail = true, validatePassword = true, isRemembered = false;


  String email= "";

  // forget pass dialog
  handleForgetPassword(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: kIsWeb?MediaQuery.of(context).size.height*0.5:MediaQuery.of(context).size.height*0.3,
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Form(
                  key: _resetFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height:MediaQuery.of(context).size.height*0.02,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text("Email", style: Theme.of(context).textTheme.bodyMedium,),
                      ),
                      TextFormField(
                        onChanged: (val){
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required to reset';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 14.0),
                        decoration: InputDecoration(
                          filled: true,
                          focusColor: Colors.black,
                          fillColor: const Color(0xFFF6F5F5),
                          prefixIcon: Icon(Icons.mail_outline, color: Colors.black.withOpacity(0.7),size: 18,),
                          contentPadding: const EdgeInsets.all(15),
                          border: InputBorder.none,
                        ),
                      ),

                      InkWell(
                        onTap: () async {
                          if(_resetFormKey.currentState!.validate()){

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const ProgressDialog(message: "Processing Your Request");
                                }
                            );

                            Navigator.pop(context);
                            email = email.replaceAll(' ', '');
                            email = email.toLowerCase();

                            // status & message map
                            var res = {
                              'status':false,
                              'message':'Went Worng!',
                            };
//                            Map res = await UserAuth().resetPassword(email);

                            if(res['status']==true){
                              Fluttertoast.showToast(msg: res['message'].toString(), timeInSecForIosWeb: 4);
                            }
                            else{
                              Fluttertoast.showToast(msg: res['message'].toString(), timeInSecForIosWeb: 4);
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.08, vertical: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text("Reset Password", textAlign:TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600),),
                        ),
                      ),
                      SizedBox(
                        height:MediaQuery.of(context).size.height*0.02,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    // if app show diff screen
      return ResponsiveUI.isMobile(context)? const UseAppDialog() :SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white10,
            resizeToAvoidBottomInset: true,
            body: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: BlocConsumer<TraderAuthBloc, TraderAuthState>(
                      builder: (context, state) {
                        if(state is TraderAuthInitialState){
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(40),
                            child: Form(
                              key: _loginKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  const SizedBox(height: 10),
                                  const Text(
                                    "TRADER LOGIN",
                                    style: TextStyle(fontSize: 28, fontFamily: "Marcellus"),
                                  ),

                                  const SizedBox(height: 30),

                                  TextFormField(
                                    focusNode: emailFN,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).requestFocus(passwordFN),
                                    textInputAction: TextInputAction.next,
                                    cursorColor: AppColors.primaryColor,
                                    controller: emailTFC,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val){
                                      if(val!.isEmpty){
                                        return "Email field can not be empty!";
                                      }
                                      else if(validatingEmail(emailTFC.text)==false){
                                        return "Please enter correct email";
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(fontSize: 16.0),
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Email",
                                        hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: const BorderSide(
                                              color:Colors.grey, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(22),
                                            borderSide: BorderSide.none
                                        ),
                                        contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 20)),
                                  ),

                                  const SizedBox(height: 20),

                                  TextFormField(
                                    controller: passwordTFC,
                                    focusNode: passwordFN,
                                    obscureText: true,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Password field can not be empty!";
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    cursorColor: AppColors.primaryColor,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(fontSize: 16.0),
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Password",
                                        hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: const BorderSide(
                                              color:Colors.grey, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(22),
                                            borderSide: BorderSide.none
                                        ),
                                        contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 20)),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(children: [
                                            Checkbox(
                                                value: isRemembered,
                                                activeColor: AppColors.primaryColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5)),
                                                onChanged: (val) {
                                                  setState(() {
                                                    isRemembered = val ?? false;
                                                  });
                                                }),
                                            const Text(
                                              "Remember me!",
                                              style: TextStyle(color: Colors.black87, fontSize: 14.0),
                                            )
                                          ]),
                                        ),
                                        TextButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          ),
                                          onPressed: () {
                                            handleForgetPassword(context);
                                          },
                                          child: const Text(
                                            "Forgot Password?",
                                            style: TextStyle(color: Colors.black87, fontSize: 14.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (_loginKey.currentState!.validate()) {
                                            BlocProvider.of<TraderAuthBloc>(context).add(TraderAuthLoginEvent(username: emailTFC.text, pass: passwordTFC.text));
                                          }
                                        },
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30))),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 20))),
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 18),
                                        )),
                                  ),

                                  const SizedBox(height: 20),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        GoRouter.of(context).push('/trader-register');
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30))),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal:  20))),
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                ],
                              ),
                            ),
                          );
                        }
                        else if ( state is TraderAuthLoadingState){
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(40),
                            child: Form(
                              key: _loginKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  const SizedBox(height: 10),
                                  const Text(
                                    "TRADER LOGIN",
                                    style: TextStyle(fontSize: 28, fontFamily: "Marcellus"),
                                  ),

                                  const SizedBox(height: 30),

                                  TextFormField(
                                    focusNode: emailFN,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).requestFocus(passwordFN),
                                    textInputAction: TextInputAction.next,
                                    cursorColor: AppColors.primaryColor,
                                    controller: emailTFC,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val){
                                      if(val!.isEmpty){
                                        return "Email field can not be empty!";
                                      }
                                      else if(validatingEmail(emailTFC.text)==false){
                                        return "Please enter correct email";
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(fontSize: 16.0),
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Email",
                                        hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: const BorderSide(
                                              color:Colors.grey, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(22),
                                            borderSide: BorderSide.none
                                        ),
                                        contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 20)),
                                  ),

                                  const SizedBox(height: 20),

                                  TextFormField(
                                    controller: passwordTFC,
                                    focusNode: passwordFN,
                                    obscureText: true,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Password field can not be empty!";
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    cursorColor: AppColors.primaryColor,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(fontSize: 16.0),
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Password",
                                        hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: const BorderSide(
                                              color:Colors.grey, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(22),
                                            borderSide: BorderSide.none
                                        ),
                                        contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 20)),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(children: [
                                            Checkbox(
                                                value: isRemembered,
                                                activeColor: AppColors.primaryColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5)),
                                                onChanged: (val) {
                                                  setState(() {
                                                    isRemembered = val ?? false;
                                                  });
                                                }),
                                            const Text(
                                              "Remember me!",
                                              style: TextStyle(color: Colors.black87, fontSize: 14.0),
                                            )
                                          ]),
                                        ),
                                        TextButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          ),
                                          onPressed: () {
                                            handleForgetPassword(context);
                                          },
                                          child: const Text(
                                            "Forgot Password?",
                                            style: TextStyle(color: Colors.black87, fontSize: 14.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                        onPressed: () {

                                        },
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30))),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 20))),
                                        child: const CircularProgressIndicator(color: Colors.white,),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        GoRouter.of(context).push('/trader-register');
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30))),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal:  20))),
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                ],
                              ),
                            ),
                          );
                        }
                        else if (state is TraderAuthFailedState){
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(40),
                            child: Form(
                              key: _loginKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  const SizedBox(height: 10),
                                  const Text(
                                    "TRADER LOGIN",
                                    style: TextStyle(fontSize: 28, fontFamily: "Marcellus"),
                                  ),

                                  const SizedBox(height: 30),

                                  TextFormField(
                                    focusNode: emailFN,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).requestFocus(passwordFN),
                                    textInputAction: TextInputAction.next,
                                    cursorColor: AppColors.primaryColor,
                                    controller: emailTFC,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val){
                                      if(val!.isEmpty){
                                        return "Email field can not be empty!";
                                      }
                                      else if(validatingEmail(emailTFC.text)==false){
                                        return "Please enter correct email";
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(fontSize: 16.0),
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Email",
                                        hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: const BorderSide(
                                              color:Colors.grey, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(22),
                                            borderSide: BorderSide.none
                                        ),
                                        contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 20)),
                                  ),

                                  const SizedBox(height: 20),

                                  TextFormField(
                                    controller: passwordTFC,
                                    focusNode: passwordFN,
                                    obscureText: true,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Password field can not be empty!";
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    cursorColor: AppColors.primaryColor,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(fontSize: 16.0),
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Password",
                                        hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: const BorderSide(
                                              color:Colors.grey, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(22),
                                            borderSide: BorderSide.none
                                        ),
                                        contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 20)),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(children: [
                                            Checkbox(
                                                value: isRemembered,
                                                activeColor: AppColors.primaryColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5)),
                                                onChanged: (val) {
                                                  setState(() {
                                                    isRemembered = val ?? false;
                                                  });
                                                }),
                                            const Text(
                                              "Remember me!",
                                              style: TextStyle(color: Colors.black87, fontSize: 14.0),
                                            )
                                          ]),
                                        ),
                                        TextButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          ),
                                          onPressed: () {
                                            handleForgetPassword(context);
                                          },
                                          child: const Text(
                                            "Forgot Password?",
                                            style: TextStyle(color: Colors.black87, fontSize: 14.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Text("LOGIN FAILED! TRY AGAIN", style: TextStyle(color: Colors.red),),

                                  const SizedBox(height: 20),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (_loginKey.currentState!.validate()) {
                                            BlocProvider.of<TraderAuthBloc>(context).add(TraderAuthLoginEvent(username: emailTFC.text, pass: passwordTFC.text));
                                          }
                                        },
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30))),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 20))),
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 18),
                                        )),
                                  ),

                                  const SizedBox(height: 20),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        GoRouter.of(context).push('/trader-register');
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30))),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal:  20))),
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                ],
                              ),
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(40),
                          child: Form(
                            key: _loginKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                const SizedBox(height: 10),
                                const Text(
                                  "TRADER LOGIN",
                                  style: TextStyle(fontSize: 28, fontFamily: "Marcellus"),
                                ),

                                const SizedBox(height: 30),

                                TextFormField(
                                  focusNode: emailFN,
                                  onEditingComplete: () =>
                                      FocusScope.of(context).requestFocus(passwordFN),
                                  textInputAction: TextInputAction.next,
                                  cursorColor: AppColors.primaryColor,
                                  controller: emailTFC,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val){
                                    if(val!.isEmpty){
                                      return "Email field can not be empty!";
                                    }
                                    else if(validatingEmail(emailTFC.text)==false){
                                      return "Please enter correct email";
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(fontSize: 16.0),
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      hintText: "Email",
                                      hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        borderSide: const BorderSide(
                                            color:Colors.grey, width: 1.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: BorderSide.none
                                      ),
                                      contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 20)),
                                ),

                                const SizedBox(height: 20),

                                TextFormField(
                                  controller: passwordTFC,
                                  focusNode: passwordFN,
                                  obscureText: true,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Password field can not be empty!";
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.done,
                                  cursorColor: AppColors.primaryColor,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(fontSize: 16.0),
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      hintText: "Password",
                                      hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        borderSide: const BorderSide(
                                            color:Colors.grey, width: 1.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: BorderSide.none
                                      ),
                                      contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 20)),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(children: [
                                          Checkbox(
                                              value: isRemembered,
                                              activeColor: AppColors.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)),
                                              onChanged: (val) {
                                                setState(() {
                                                  isRemembered = val ?? false;
                                                });
                                              }),
                                          const Text(
                                            "Remember me!",
                                            style: TextStyle(color: Colors.black87, fontSize: 14.0),
                                          )
                                        ]),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        ),
                                        onPressed: () {
                                          handleForgetPassword(context);
                                        },
                                        child: const Text(
                                          "Forgot Password?",
                                          style: TextStyle(color: Colors.black87, fontSize: 14.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (_loginKey.currentState!.validate()) {
                                          BlocProvider.of<TraderAuthBloc>(context).add(TraderAuthLoginEvent(username: emailTFC.text, pass: passwordTFC.text));
                                        }
                                      },
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30))),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal: 20))),
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 18),
                                      )),
                                ),

                                const SizedBox(height: 20),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      GoRouter.of(context).push('/trader-register');
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30))),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 15,
                                                horizontal:  20))),
                                    child: const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                              ],
                            ),
                          ),
                        );
                      },

                      listener: (context, state){
                        if(state is TraderAuthLoadedState){
                          Provider.of<AuthenticationProvider>(context, listen: false).addUserInfo(state.user);
                          Provider.of<LoginStateProvider>(context, listen: false).addUserId(state.user.userId);
                          Provider.of<LoginStateProvider>(context, listen: false).addUserEmail(state.user.email);
                          Provider.of<LoginStateProvider>(context, listen: false).addUserFullName(state.user.fullName);
                          Provider.of<LoginStateProvider>(context, listen: false).addUserType(UserType.trader);
                          Fluttertoast.showToast(msg: 'LOGGED IN ${state.user.email}');
                          GoRouter.of(context).push('/trader');
                        }
                      },
                    ),
                  ),
                ),

                ResponsiveUI.isMobile(context) ? Container() : Expanded(
                  flex: 3,
                  child: Container(
                    color: AppColors.primaryColor,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: Image.asset(AppAssets.bannerImageLogin),
                    ),
                  ),
                ),

              ],
            )
        ),
      );
  }
}
