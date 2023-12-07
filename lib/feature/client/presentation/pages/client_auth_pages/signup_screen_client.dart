import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:workoneerweb/core/responsive/responsive_ui.dart';
import 'package:workoneerweb/core/responsive/use_mobile_app_dialog.dart';
import 'package:workoneerweb/core/utils/validators.dart';
import 'package:workoneerweb/feature/auth/data/model/user_model.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/auth/presentation/providers/authentication_provider.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/client_auth_bloc.dart';

import '/configs/app_assets.dart';
import '/configs/app_colors.dart';


class SignUpScreenClient extends StatefulWidget {
  const SignUpScreenClient({Key? key}) : super(key: key);

  @override
  State<SignUpScreenClient> createState() => _SignUpScreenClientState();
}

class _SignUpScreenClientState extends State<SignUpScreenClient> {
  final emailTFC = TextEditingController(),
      passwordTFC = TextEditingController(),
      postCodeTFC = TextEditingController(),
      nameTFC = TextEditingController(),
      phoneTFC = TextEditingController(),
      confirmPasswordTFC = TextEditingController();

  final FocusNode passwordFN = FocusNode(),
      emailFN = FocusNode(),
      nameFN = FocusNode(),
      phoneFN = FocusNode(),
      confirmPasswordFN = FocusNode();

  bool isAgreed = false;

  final _signUpFormKey = GlobalKey<FormState>();

  Country yourCountry = const Country(
    name: "Australia",
    nameTranslations: {
      "en": "Australia",
    },
    flag: "🇦🇺",
    code: "AU",
    dialCode: "61",
    minLength: 9,
    maxLength: 9,
  );

  Country np = const Country(
    name: "Nepal",
    nameTranslations: {
      "en": "Nepal",
    },
    flag: "🇳🇵",
    code: "NP",
    dialCode: "977",
    minLength: 10,
    maxLength: 10,
  );

  Country aus = const Country(
    name: "Australia",
    nameTranslations: {
      "en": "Australia",
    },
    flag: "🇦🇺",
    code: "AU",
    dialCode: "61",
    minLength: 9,
    maxLength: 9,
  );

  Country gb = const Country(
    name: "United Kingdom",
    nameTranslations: {
      "en": "United Kingdom",
    },
    flag: "🇬🇧",
    code: "GB",
    dialCode: "44",
    minLength: 10,
    maxLength: 10,
  );


  @override
  Widget build(BuildContext context) {
          // if mobile show different view
          return ResponsiveUI.isMobile(context)? const UseAppDialog() : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white10,
              resizeToAvoidBottomInset: true,
              body: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: BlocConsumer<ClientAuthBloc, ClientAuthState>(
                        builder: (context, state){
                          if(state is ClientAuthInitialState){
                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(40),
                              child: Form(
                                key: _signUpFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        AppAssets.profileIcn,
                                        height: 80,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    const Text(
                                      "CLIENT SIGNUP",
                                      style: TextStyle(fontSize: 24, fontFamily: "Marcellus"),
                                    ),

                                    const SizedBox(height: 20),

                                    TextFormField(
                                      focusNode: nameFN,
                                      onEditingComplete: () =>
                                          FocusScope.of(context).requestFocus(phoneFN),
                                      textInputAction: TextInputAction.next,
                                      cursorColor: AppColors.primaryColor,
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Name field can not be empty!";
                                        }
                                        return null;
                                      },
                                      controller: nameTFC,
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Full Name",
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
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    IntlPhoneField(
                                      countries: [aus, gb, np],
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                          hintText: "Mobile",
                                          hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat", fontSize: 18.0),
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
                                      initialCountryCode: 'AU',
                                      onCountryChanged: (val){
                                        setState(() {
                                          yourCountry = val;
                                        });
                                      },
                                      onChanged: (phone) {
                                        phoneTFC.text = phone.completeNumber;
                                      },
                                    ),

                                    TextFormField(
                                      focusNode: emailFN,
                                      onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFN),
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
                                      textAlignVertical: TextAlignVertical.top,
                                      style: const TextStyle(fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Email",
                                        hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: const BorderSide(color:Colors.grey, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(22),
                                            borderSide: BorderSide.none
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),


                                    TextFormField(
                                      controller: postCodeTFC,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: AppColors.primaryColor,
                                      keyboardType: TextInputType.text,
                                      textAlignVertical: TextAlignVertical.top,
                                      style: const TextStyle(fontSize: 16.0),
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Postcode can't be empty!";
                                        }
                                        return null;
                                      },

                                      decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Post Code",
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
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    TextFormField(
                                      controller: passwordTFC,
                                      focusNode: passwordFN,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: AppColors.primaryColor,
                                      keyboardType: TextInputType.text,
                                      textAlignVertical: TextAlignVertical.top,
                                      style: const TextStyle(fontSize: 16.0),
                                      obscureText: true,
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Password field can not be empty!";
                                        }
                                        else if(val.length<8){
                                          return "Password length must be greater than 8 chars.";
                                        }
                                        return null;
                                      },
                                      onEditingComplete: () => FocusScope.of(context)
                                          .requestFocus(confirmPasswordFN),
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
                                        const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(

                                          children: [

                                            Checkbox(
                                              value: isAgreed,
                                              activeColor: AppColors.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)),
                                              onChanged: (val) {
                                                setState(() {
                                                  isAgreed = val ?? false;
                                                });
                                              },
                                            ),

                                            const Text(
                                              "I agree with the ",
                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                                            ),

                                            InkWell(
                                              onTap: () {},
                                              child: const Text(
                                                "terms of use",
                                                style: TextStyle(color: Colors.black87,decoration: TextDecoration.underline,
                                                    fontWeight: FontWeight.bold, fontSize: 18.0),),
                                            ),

                                          ]),
                                    ),

                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_signUpFormKey.currentState!.validate()) {
                                            UserModel user = UserModel(
                                                userId: '',
                                                email: emailTFC.text,
                                                fullName: nameTFC.text,
                                                phone: phoneTFC.text,
                                                status: 'LIVE',
                                                profilePhoto: '',
                                                postCode: postCodeTFC.text,
                                                streetAddress: '',
                                                country: phoneTFC.text.startsWith('+61')?'Australia':'United Kingdom',
                                                userType: UserType.client,
                                            );

                                            BlocProvider.of<ClientAuthBloc>(context).add(ClientAuthRegisterEvent(user: user, pass: passwordTFC.text));

                                          }
                                        },
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30))),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal:  15))
                                        ),
                                        child: const Text(
                                          "Signup",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 18),
                                        ),),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                      child: Row(
                                          children: [

                                            const Text(
                                              "Already have an account? ",
                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                                            ),

                                            InkWell(
                                              onTap: () {
                                                GoRouter.of(context).push('/client-login');
                                              },

                                              child: Text(
                                                "Login",
                                                style: Theme.of(context).textTheme.bodyText2!.
                                                copyWith(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          } else if (state is ClientAuthLoadingState){
                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(40),
                              child: Form(
                                key: _signUpFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        AppAssets.profileIcn,
                                        height: 80,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    const Text(
                                      "CLIENT SIGNUP",
                                      style: TextStyle(fontSize: 24, fontFamily: "Marcellus"),
                                    ),

                                    const SizedBox(height: 20),

                                    TextFormField(
                                      focusNode: nameFN,
                                      onEditingComplete: () =>
                                          FocusScope.of(context).requestFocus(phoneFN),
                                      textInputAction: TextInputAction.next,
                                      cursorColor: AppColors.primaryColor,
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Name field can not be empty!";
                                        }
                                        return null;
                                      },
                                      controller: nameTFC,
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Full Name",
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
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    IntlPhoneField(
                                      countries: [aus, gb, np],
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                          hintText: "Mobile",
                                          hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat", fontSize: 18.0),
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
                                      initialCountryCode: 'AU',
                                      onCountryChanged: (val){
                                        setState(() {
                                          yourCountry = val;
                                        });
                                      },
                                      onChanged: (phone) {
                                        phoneTFC.text = phone.completeNumber;
                                      },
                                    ),

                                    TextFormField(
                                      focusNode: emailFN,
                                      onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFN),
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
                                      textAlignVertical: TextAlignVertical.top,
                                      style: const TextStyle(fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Email",
                                        hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: const BorderSide(color:Colors.grey, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(22),
                                            borderSide: BorderSide.none
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    TextFormField(
                                      controller: postCodeTFC,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: AppColors.primaryColor,
                                      keyboardType: TextInputType.text,
                                      textAlignVertical: TextAlignVertical.top,
                                      style: const TextStyle(fontSize: 16.0),
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Postcode can't be empty!";
                                        }
                                        return null;
                                      },

                                      decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Post Code",
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
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    TextFormField(
                                      controller: passwordTFC,
                                      focusNode: passwordFN,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: AppColors.primaryColor,
                                      keyboardType: TextInputType.text,
                                      textAlignVertical: TextAlignVertical.top,
                                      style: const TextStyle(fontSize: 16.0),
                                      obscureText: true,
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Password field can not be empty!";
                                        }
                                        else if(val.length<8){
                                          return "Password length must be greater than 8 chars.";
                                        }
                                        return null;
                                      },
                                      onEditingComplete: () => FocusScope.of(context)
                                          .requestFocus(confirmPasswordFN),
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
                                        const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(

                                          children: [

                                            Checkbox(
                                              value: isAgreed,
                                              activeColor: AppColors.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)),
                                              onChanged: (val) {
                                                setState(() {
                                                  isAgreed = val ?? false;
                                                });
                                              },
                                            ),

                                            const Text(
                                              "I agree with the ",
                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                                            ),

                                            InkWell(
                                              onTap: () {},
                                              child: const Text(
                                                "terms of use",
                                                style: TextStyle(color: Colors.black87,decoration: TextDecoration.underline,
                                                    fontWeight: FontWeight.bold, fontSize: 18.0),),
                                            )
                                          ]),
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
                                                EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal:  MediaQuery.of(context).size.width / 6))
                                        ),
                                        child: const CircularProgressIndicator(color: Colors.white,),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                      child: Row(
                                          children: [

                                            const Text(
                                              "Already have an account? ",
                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                                            ),

                                            InkWell(
                                              onTap: () {
                                                GoRouter.of(context).push('/client-login');
                                              },

                                              child: Text(
                                                "Login",
                                                style: Theme.of(context).textTheme.bodyText2!.
                                                copyWith(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          } else if (state is ClientAuthFailedState){
                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(40),
                              child: Form(
                                key: _signUpFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        AppAssets.profileIcn,
                                        height: 80,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    const Text(
                                      "CLIENT SIGNUP",
                                      style: TextStyle(fontSize: 24, fontFamily: "Marcellus"),
                                    ),

                                    const SizedBox(height: 20),

                                    TextFormField(
                                      focusNode: nameFN,
                                      onEditingComplete: () =>
                                          FocusScope.of(context).requestFocus(phoneFN),
                                      textInputAction: TextInputAction.next,
                                      cursorColor: AppColors.primaryColor,
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Name field can not be empty!";
                                        }
                                        return null;
                                      },
                                      controller: nameTFC,
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Full Name",
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
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    IntlPhoneField(
                                      countries: [aus, gb, np],
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                          hintText: "Mobile",
                                          hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat", fontSize: 18.0),
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
                                      initialCountryCode: 'AU',
                                      onCountryChanged: (val){
                                        setState(() {
                                          yourCountry = val;
                                        });
                                      },
                                      onChanged: (phone) {
                                        phoneTFC.text = phone.completeNumber;
                                      },
                                    ),

                                    TextFormField(
                                      focusNode: emailFN,
                                      onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFN),
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
                                      textAlignVertical: TextAlignVertical.top,
                                      style: const TextStyle(fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Email",
                                        hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: const BorderSide(color:Colors.grey, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(22),
                                            borderSide: BorderSide.none
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    TextFormField(
                                      controller: postCodeTFC,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: AppColors.primaryColor,
                                      keyboardType: TextInputType.text,
                                      textAlignVertical: TextAlignVertical.top,
                                      style: const TextStyle(fontSize: 16.0),
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Postcode can't be empty!";
                                        }
                                        return null;
                                      },

                                      decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Post Code",
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
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    TextFormField(
                                      controller: passwordTFC,
                                      focusNode: passwordFN,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: AppColors.primaryColor,
                                      keyboardType: TextInputType.text,
                                      textAlignVertical: TextAlignVertical.top,
                                      style: const TextStyle(fontSize: 16.0),
                                      obscureText: true,
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Password field can not be empty!";
                                        }
                                        else if(val.length<8){
                                          return "Password length must be greater than 8 chars.";
                                        }
                                        return null;
                                      },
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
                                        const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(

                                          children: [

                                            Checkbox(
                                              value: isAgreed,
                                              activeColor: AppColors.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)),
                                              onChanged: (val) {
                                                setState(() {
                                                  isAgreed = val ?? false;
                                                });
                                              },
                                            ),

                                            const Text(
                                              "I agree with the ",
                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                                            ),

                                            InkWell(
                                              onTap: () {},
                                              child: const Text(
                                                "terms of use",
                                                style: TextStyle(color: Colors.black87,decoration: TextDecoration.underline,
                                                    fontWeight: FontWeight.bold, fontSize: 18.0),),
                                            )
                                          ]),
                                    ),

                                    Text('Failed to create account. ${state.errorText.text}', style: const TextStyle(color: Colors.red),),

                                    const SizedBox(height: 10.0,),

                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_signUpFormKey.currentState!.validate()) {
                                            UserModel user = UserModel(
                                              userId: '',
                                              email: emailTFC.text,
                                              fullName: nameTFC.text,
                                              phone: phoneTFC.text,
                                              status: 'LIVE',
                                              profilePhoto: '',
                                              postCode: postCodeTFC.text,
                                              streetAddress: '',
                                              country: phoneTFC.text.startsWith('+61')?'Australia':'United Kingdom',
                                              userType: UserType.client,
                                            );

                                            BlocProvider.of<ClientAuthBloc>(context).add(ClientAuthRegisterEvent(user: user, pass: passwordTFC.text));

                                          }
                                        },
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30))),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal:  MediaQuery.of(context).size.width / 6))
                                        ),
                                        child: const Text(
                                          "Signup",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 18),
                                        ),),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                      child: Row(
                                          children: [

                                            const Text(
                                              "Already have an account? ",
                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                                            ),

                                            InkWell(
                                              onTap: () {
                                                GoRouter.of(context).push('/client-login');
                                              },

                                              child: Text(
                                                "Login",
                                                style: Theme.of(context).textTheme.bodyText2!.
                                                copyWith(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          } else if ( state is ClientAuthLoadedState){
                            return Center(
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
                                    child: Text("Setting up things for you!", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w800, fontSize: 18.0),),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.01),
                                    child: const Text("LOGGING YOU IN. JUST A SECOND!", style: TextStyle(color:Color(0xFFDADADA), fontSize: 16.0),),
                                  ),

                                ],
                              ),
                            );
                          }
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(40),
                            child: Form(
                              key: _signUpFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset(
                                      AppAssets.profileIcn,
                                      height: 80,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  const Text(
                                    "CLIENT SIGNUP",
                                    style: TextStyle(fontSize: 24, fontFamily: "Marcellus"),
                                  ),

                                  const SizedBox(height: 20),

                                  TextFormField(
                                    focusNode: nameFN,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).requestFocus(phoneFN),
                                    textInputAction: TextInputAction.next,
                                    cursorColor: AppColors.primaryColor,
                                    validator: (val){
                                      if(val!.isEmpty){
                                        return "Name field can not be empty!";
                                      }
                                      return null;
                                    },
                                    controller: nameTFC,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(fontSize: 16.0),
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      hintText: "Full Name",
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
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  IntlPhoneField(
                                    countries: [aus, gb, np],
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Mobile",
                                        hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat", fontSize: 18.0),
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
                                    initialCountryCode: 'AU',
                                    onCountryChanged: (val){
                                      setState(() {
                                        yourCountry = val;
                                      });
                                    },
                                    onChanged: (phone) {
                                      phoneTFC.text = phone.completeNumber;
                                    },
                                  ),

                                  TextFormField(
                                    focusNode: emailFN,
                                    onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFN),
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
                                    textAlignVertical: TextAlignVertical.top,
                                    style: const TextStyle(fontSize: 16.0),
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      hintText: "Email",
                                      hintStyle: const TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        borderSide: const BorderSide(color:Colors.grey, width: 1.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(22),
                                          borderSide: BorderSide.none
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  TextFormField(
                                    controller: passwordTFC,
                                    focusNode: passwordFN,
                                    textInputAction: TextInputAction.next,
                                    cursorColor: AppColors.primaryColor,
                                    keyboardType: TextInputType.text,
                                    textAlignVertical: TextAlignVertical.top,
                                    style: const TextStyle(fontSize: 16.0),
                                    obscureText: true,
                                    validator: (val){
                                      if(val!.isEmpty){
                                        return "Password field can not be empty!";
                                      }
                                      else if(val.length<8){
                                        return "Password length must be greater than 8 chars.";
                                      }
                                      return null;
                                    },
                                    onEditingComplete: () => FocusScope.of(context)
                                        .requestFocus(confirmPasswordFN),
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
                                      const EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  TextFormField(
                                    controller: confirmPasswordTFC,
                                    focusNode: confirmPasswordFN,
                                    textInputAction: TextInputAction.done,
                                    cursorColor: AppColors.primaryColor,
                                    keyboardType: TextInputType.text,
                                    textAlignVertical: TextAlignVertical.top,
                                    obscureText: true,
                                    style: const TextStyle(fontSize: 16.0),
                                    validator: (val){
                                      if(val!.isEmpty){
                                        return "Password field can not be empty!";
                                      }
                                      else if(passwordTFC.text!=confirmPasswordTFC.text){
                                        return "Password didnot match";
                                      }
                                      return null;
                                    },

                                    decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      hintText: "Confirm Password",
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
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(

                                        children: [

                                          Checkbox(
                                            value: isAgreed,
                                            activeColor: AppColors.primaryColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)),
                                            onChanged: (val) {
                                              setState(() {
                                                isAgreed = val ?? false;
                                              });
                                            },
                                          ),

                                          const Text(
                                            "I agree with the ",
                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                                          ),

                                          InkWell(
                                            onTap: () {},
                                            child: const Text(
                                              "terms of use",
                                              style: TextStyle(color: Colors.black87,decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold, fontSize: 18.0),),
                                          )
                                        ]),
                                  ),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_signUpFormKey.currentState!.validate()) {

                                          UserModel user = UserModel(
                                            userId: '',
                                            email: emailTFC.text,
                                            fullName: nameTFC.text,
                                            phone: phoneTFC.text,
                                            status: 'LIVE',
                                            profilePhoto: '',
                                            postCode: postCodeTFC.text,
                                            streetAddress: '',
                                            country: phoneTFC.text.startsWith('+61')?'Australia':'United Kingdom',
                                            userType: UserType.client,
                                          );

                                          BlocProvider.of<ClientAuthBloc>(context).add(ClientAuthRegisterEvent(user: user, pass: passwordTFC.text));

                                        }
                                      },
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30))),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal:  MediaQuery.of(context).size.width / 6))
                                      ),
                                      child: const Text(
                                        "Signup",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 18),
                                      ),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                    child: Row(
                                        children: [

                                          const Text(
                                            "Already have an account? ",
                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                                          ),

                                          InkWell(
                                            onTap: () {
                                              GoRouter.of(context).push('/client-login');
                                            },

                                            child: Text(
                                              "Login",
                                              style: Theme.of(context).textTheme.bodyText2!.
                                              copyWith(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  decoration: TextDecoration.underline),
                                            ),
                                          ),
                                        ]
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );
                        },
                        listener:  (context,state){
                          if(state is ClientAuthLoadedState){
                            Provider.of<AuthenticationProvider>(context, listen: false).addUserInfo(state.user);

                            Fluttertoast.showToast(msg: 'Yahoo! Your account created!');
                            GoRouter.of(context).push('/client');
                          }
                        },
                      ),
                    ),
                  ),

                  ResponsiveUI.isMobile(context) ?

                  Container()

                      :

                  Expanded(
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
              ),
            ),
          );
  }
}
