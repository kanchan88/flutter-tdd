
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workoneerweb/configs/app_assets.dart';
import 'package:workoneerweb/configs/app_colors.dart';
import 'package:workoneerweb/core/responsive/responsive_ui.dart';
import 'package:workoneerweb/feature/client/presentation/pages/billing_view.dart';
import 'package:workoneerweb/feature/client/presentation/pages/my_account.dart';
import 'package:workoneerweb/feature/client/presentation/pages/my_auctions_view.dart';

class ClientDashboard extends StatefulWidget {

  const ClientDashboard({ Key? key}) : super(key: key);

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {

  bool isMyAuction = true;
  bool isBilling = false;
  bool isMyAccount = false;
  bool isSupport = false;


  @override
  Widget build(BuildContext context) {
    // show diff view for mobile
    return  Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView(

        children: [

          // main header
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.07, vertical: MediaQuery.of(context).size.height*0.05 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Image.asset(
                  AppAssets.appLogo,
                  width: MediaQuery.of(context).size.width * 0.2,
                ),

                Row(

                  children: [

                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(CupertinoIcons.bell_fill),
                    ),

                    const CircleAvatar(radius: 20.0,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Gabriel Moises", style: Theme.of(context).textTheme.bodyText2,),
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
                        isSupport = false;
                      });
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
                        isSupport = false;
                      });
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
                      decoration: isSupport? const BoxDecoration(
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

          // body
          Container(
            padding: ResponsiveUI.isTablet(context) || ResponsiveUI.isMobile(context) ? const EdgeInsets.all(8.0) : EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.07),
            child:
            isMyAuction ? const ShowMyAuctions():
            isBilling? const ShowBillingViewClient():
            isSupport? const ShowMyAuctions():
            const ShowMyAccountClient(),
          ),

          const SizedBox(height: 100.0,),

          Container(
            height: 2.0,
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 25.0,),

          // footer
          Container(
            padding: ResponsiveUI.isTablet(context) ? const EdgeInsets.all(8.0) : EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.07),
            child: ResponsiveUI.isTablet(context)?Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Quick Links",
                            style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black87),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Find Talents",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Find Works",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),

                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Recommendation",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Guides",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Blogs",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Mission Statement",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "The Team",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Contact Us",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),

                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Follow Us",
                            style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black87),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(FontAwesomeIcons.instagram),
                            SizedBox(width: 6.0,),
                            Icon(FontAwesomeIcons.facebook),
                            SizedBox(width: 6.0,),
                            Icon(FontAwesomeIcons.tiktok),
                            SizedBox(width: 6.0,),
                            Icon(FontAwesomeIcons.youtube),
                            SizedBox(width: 6.0,),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ):Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Quick Links",
                        style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black87),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Find Talents",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Find Works",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),

                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "",
                        style: TextStyle(fontSize: 24.0, fontFamily: "Marcellus"),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Recommendation",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Guides",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Blogs",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),

                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "",
                        style:
                        TextStyle(fontSize: 24.0, fontFamily: "Marcellus"),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Mission Statement",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "The Team",
                        style: Theme.of(context).textTheme.bodyText1,

                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Contact Us",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),

                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Follow Us",
                        style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black87),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [

                        Icon(FontAwesomeIcons.instagram),
                        SizedBox(width: 6.0,),

                        Icon(FontAwesomeIcons.facebook),
                        SizedBox(width: 6.0,),

                        Icon(FontAwesomeIcons.tiktok),
                        SizedBox(width: 6.0,),

                        Icon(FontAwesomeIcons.youtube),
                        SizedBox(width: 6.0,),

                      ],
                    ),

                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 100.0,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${DateTime.now().year} Workoneer. All Rights Reserved", style: const TextStyle(fontSize: 16.0,),),
            ],
          ),

          const SizedBox(height: 25.0,),

        ],
      ),
    );
  }
}

