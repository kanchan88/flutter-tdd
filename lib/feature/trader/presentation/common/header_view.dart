import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/configs/app_assets.dart';
import '/configs/app_colors.dart';
import '/core/provider/login_state_provider.dart';
import '/feature/client/presentation/common/header_view.dart';
import '/feature/trader/presentation/common/header_trader_global.dart';
import '../../../auth/domain/entities/user.dart';

class HeaderTrader extends StatefulWidget {
  const HeaderTrader({Key? key}) : super(key: key);


  @override
  State<HeaderTrader> createState() => _HeaderTraderState();
}

class _HeaderTraderState extends State<HeaderTrader> {

  bool isInternet = true;

  checkIfInternet() async {

    ConnectivityResult result = await Connectivity().checkConnectivity();

    if(result==ConnectivityResult.none){
      setState(() {
        isInternet = false;
      });
    }
    else{
      setState(() {
        isInternet = true;
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Provider.of<LoginStateProvider>(context, listen:false).getUserType==UserType.client ? Column(

        children: [

          // main header
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.07, vertical: MediaQuery.of(context).size.height*0.05 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                GestureDetector(
                  onTap:(){
                    GoRouter.of(context).go("/client");
                    setState(() {
                      isMyAuction = true;
                      isBilling = false;
                      isMyAccount = false;
                      isSupport = false;
                    });
                  },
                  child: Image.asset(
                    AppAssets.appLogo,
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),

                Row(

                  children: [

                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(CupertinoIcons.bell_fill),
                    ),

                    // TODO: shared pref user photo
                    const CircleAvatar(
                        radius: 20.0, backgroundImage: NetworkImage(''),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(Provider.of<LoginStateProvider>(context,listen: false).getFullName.toString(), style: Theme.of(context).textTheme.bodyText2,),
                    ),

                  ],
                )
              ],
            ),
          ),

          Container(
            height: 2.0,
            color: Colors.grey.shade300,
          ),

          // menu
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.07, vertical: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  InkWell(
                    onTap: (){
                      setState(() {
                        isMyAuction = true;
                        isBilling = false;
                        isMyAccount = false;
                        isSupport = false;
                      });
                      GoRouter.of(context).go("/client");
                    },
                    child: Container(
                      decoration: isMyAuction ? const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.primaryColor, width: 3.0)
                        ),
                      ): const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text("My Auctions", style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w800),),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      setState(() {
                        isMyAuction = false;
                        isBilling = true;
                        isMyAccount = false;
                        isSupport = false;
                      });
                      GoRouter.of(context).go("/client/billing");
                    },
                    child: Container(
                      decoration: isBilling? const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.primaryColor, width: 3.0)
                        ),
                      ): const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text("Billing", style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w800),),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      setState(() {
                        isMyAuction = false;
                        isBilling = false;
                        isMyAccount = true;
                        isSupport = false;
                      });
                      GoRouter.of(context).go("/client/account");
                    },
                    child: Container(
                      decoration: isMyAccount? const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.primaryColor, width: 3.0)
                        ),): const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text("My Account", style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w800),),
                    ),
                  ),

                  InkWell(

                    onTap: (){
                      setState(() {
                        isMyAuction = false;
                        isBilling = false;
                        isMyAccount = false;
                        isSupport = true;
                      });
                    },

                    child: Container(
                      decoration: isSupport ? const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.primaryColor, width: 3.0)
                        ),
                      ): const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text("Support", style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w800),),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ):
      Column(

        children: [

          // main header
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.07, vertical: MediaQuery.of(context).size.height*0.05 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                GestureDetector(
                  onTap:(){
                    GoRouter.of(context).go("/trader");
                  },
                  child: Image.asset(
                    AppAssets.appLogo,
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),

                Row(

                  children: [

                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(CupertinoIcons.bell_fill),
                    ),


                    // TODO: user prefs photo
                    const CircleAvatar(radius: 20.0, backgroundImage: NetworkImage('')),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(Provider.of<LoginStateProvider>(context,listen: false).getFullName.toString(), style: Theme.of(context).textTheme.bodyText2,),
                    ),

                  ],
                )
              ],
            ),
          ),

          Container(
            height: 2.0,
            color: Colors.grey.shade300,
          ),

          // menu
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.07, vertical: 18.0),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  InkWell(
                    onTap: (){
                      setState(() {
                        isAllAuction = true;
                        isTraderBilling = false;
                        isTraderAccount = false;
                        isTraderSupport = false;
                      });
                      GoRouter.of(context).go("/trader");
                    },
                    child: Container(
                      decoration: isAllAuction ? const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.primaryColor, width: 3.0)
                        ),
                      ): const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text("All Auctions", style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w800),),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      setState(() {
                        isAllAuction = false;
                        isTraderBilling = true;
                        isTraderAccount = false;
                        isTraderSupport = false;
                      });
                      GoRouter.of(context).go("/trader/billing");
                    },
                    child: Container(
                      decoration: isTraderBilling? const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.primaryColor, width: 3.0)
                        ),
                      ): const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text("Billing", style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w800),),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      setState(() {
                        isAllAuction = false;
                        isTraderBilling = false;
                        isTraderAccount = true;
                        isTraderSupport = false;
                      });
                      GoRouter.of(context).go("/trader/account");
                    },
                    child: Container(
                      decoration: isTraderAccount? const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.primaryColor, width: 3.0)
                        ),): const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text("My Account", style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w800),),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      setState(() {
                        isAllAuction = false;
                        isTraderBilling = false;
                        isTraderAccount = false;
                        isTraderSupport = true;
                      });
                    },
                    child: Container(
                      decoration: isTraderSupport ? const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.primaryColor, width: 3.0)
                        ),): const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text("Support", style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w800),),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
