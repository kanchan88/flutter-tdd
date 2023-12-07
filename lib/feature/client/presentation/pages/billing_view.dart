import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workoneerweb/core/responsive/responsive_ui.dart';
import 'package:workoneerweb/core/responsive/use_mobile_app_dialog.dart';
import '/configs/app_colors.dart';
import 'package:workoneerweb/feature/client/presentation/common/header_view.dart';
import 'package:workoneerweb/feature/client/presentation/widgets/single_billing_list.dart';

class ShowBillingViewClient extends StatefulWidget {

  const ShowBillingViewClient({Key? key}):super(key: key);

  @override
  State<ShowBillingViewClient> createState() => _ShowBillingViewClientState();
}

class _ShowBillingViewClientState extends State<ShowBillingViewClient> {

  final double _consumedData = 16/40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveUI.isMobile(context)? const UseAppDialog() : ListView(
        children: [

          const Header(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.07, vertical: MediaQuery.of(context).size.height*0.05 ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
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
                                  "BILLINGS",
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Manage your billing and payment details",
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
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height*0.4,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04, vertical: MediaQuery.of(context).size.width*0.02),
                                      height: MediaQuery.of(context).size.height*0.35,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 8.0),
                                                        child: Text("B Grade", style: Theme.of(context).textTheme.headline6,),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {},
                                                        style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                                                            shape: MaterialStateProperty.all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(30))),
                                                            padding: MaterialStateProperty.all(
                                                                const EdgeInsets.symmetric(
                                                                    vertical: 5, horizontal: 10.0
                                                                ))),
                                                        child: const Text(
                                                            "Monthly",
                                                            style:TextStyle(
                                                                fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white)),

                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Row(
                                                    children: [

                                                      Text("\$100", style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 32.0),),

                                                      Text("/month", style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14.0),),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          SizedBox(
                                            height: MediaQuery.of(context).size.height*0.03,
                                          ),

                                          Text(
                                            "No of bids",
                                            style: Theme.of(context).textTheme.headline6!.copyWith(fontSize:14.0),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height*0.01,
                                          ),
                                          ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            child: LinearProgressIndicator(
                                              value: _consumedData,
                                              backgroundColor: AppColors.primaryColorOff,
                                              minHeight: 6.0,
                                            ),
                                          ),

                                          SizedBox(
                                            height: MediaQuery.of(context).size.height*0.01,
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(""),
                                              Row(
                                                children: [
                                                  const Text("Upgrade Plan", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w800),),

                                                  Row(
                                                    children: [
                                                      const Text(""),
                                                      IconButton(onPressed: (){}, icon: const FaIcon(FontAwesomeIcons.squareArrowUpRight))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),


                                        ],
                                      )
                                  ),
                                ),

                                SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                                Expanded(
                                  child: Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04, vertical: MediaQuery.of(context).size.width*0.02),
                                      height: MediaQuery.of(context).size.height*0.35,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text("Payment Method", style: Theme.of(context).textTheme.headline6,),

                                          const SizedBox(
                                            height: 4,
                                          ),

                                          const Text("Change how you pay for your plan", style: TextStyle(fontSize: 14.0),),

                                          const SizedBox(
                                            height: 10,
                                          ),

                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey.shade300)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [

                                                  Row(

                                                    children: [

                                                      SizedBox(width: MediaQuery.of(context).size.width*0.01,),

                                                      FaIcon(FontAwesomeIcons.ccVisa, size: MediaQuery.of(context).size.width*0.03,),

                                                      SizedBox(width: MediaQuery.of(context).size.width*0.02),

                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children:  [
                                                          Padding(
                                                            padding: const EdgeInsets.only(bottom: 4.0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: const [

                                                                Text("Visa ending in 1234", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w800),),

                                                                Icon(Icons.edit, size: 16.0,)
                                                              ],
                                                            ),
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets.only(bottom: 6.0),
                                                              child: Text("Expiry 06/2024", style: TextStyle(fontSize: 14.0),)),

                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Icon(Icons.email_outlined, size: 18.0, color: Colors.grey.shade300,),
                                                              const Text("billing@gmail.com", style: TextStyle(fontSize: 14.0),),
                                                            ],
                                                          ),
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.height*0.03,
                            ),
                          ],
                        )),
                  ),

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
                                  "BILLING & INCOIVING",
                                  style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 18.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Pick an account plant that fits your workflow.",
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
                    const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.25,
                              child: Row(
                                children: [
                                  Checkbox(
                                    onChanged: (b){},
                                    value: false,
                                  ),
                                  const Text("Invoice",
                                      textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 14.0)),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.15,
                              child: const Text("Billing Date",
                                  textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 14.0)),
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.1,
                              child: const Text("Status",
                                  textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 14.0)),
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.1,
                              child: const Text("Amount",
                                  textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 14.0)),
                            ),


                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.2,
                              child: const Text("Plan",
                                  textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 14.0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: 5,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index){
                        return SingleBillingList(index: index);
                      },
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
