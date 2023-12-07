import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workoneerweb/core/provider/login_state_provider.dart';
import 'package:workoneerweb/feature/auth/presentation/providers/authentication_provider.dart';
import 'package:workoneerweb/feature/client/presentation/widgets/sidebar_dashboard.dart';
import 'package:workoneerweb/feature/trader/presentation/bloc/trader_auction_bloc.dart';
import 'package:workoneerweb/feature/trader/presentation/common/header_view.dart';
import 'package:workoneerweb/feature/trader/presentation/common/un_autenticated_view.dart';
import 'package:workoneerweb/feature/trader/presentation/containers/trader_live_auction_container.dart';
import 'package:workoneerweb/feature/trader/presentation/containers/trader_won_auction_container.dart';
import 'package:workoneerweb/injection_container.dart';
import '../../../../core/responsive/responsive_ui.dart';
import '../../../../core/responsive/use_mobile_app_dialog.dart';
import '../../../auth/domain/entities/user.dart';
import '/configs/app_colors.dart';

class AllAuctionsTraderView extends StatefulWidget {
  const AllAuctionsTraderView({Key? key}) : super(key: key);

  @override
  State<AllAuctionsTraderView> createState() => _AllAuctionsTraderViewState();
}

class _AllAuctionsTraderViewState extends State<AllAuctionsTraderView> {

  bool isWon = false;

  List<String> sortByType = ["Date", "Bids", "Status"];

  String sortByValue = "Date";

  @override
  Widget build(BuildContext context) {

    return ResponsiveUI.isMobile(context)? const UseAppDialog() : Scaffold(
      body: ListView(
        children: [

          const HeaderTrader(),

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

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "ALL AUCTIONS",
                              style: Theme.of(context).textTheme.headline3,
                            ),
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
                    child: Provider.of<LoginStateProvider>(context, listen:false).getUserType!=UserType.trader ? const UnAuthenticatedView(user: 'trader'):
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Expanded(
                            flex: 2,
                            child: Sidebar(),
                        ),

                        const SizedBox(
                          width: 20.0,
                        ),

                        Expanded(
                          flex: 4,
                          child: Container(
                              height: MediaQuery.of(context).size.height,
                              decoration: const BoxDecoration(color: Colors.white),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Positioned(
                                        top: 57,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.grey,
                                          height: 1.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isWon = false;
                                                });
                                              },
                                              child: Container(
                                                decoration: !isWon
                                                    ? const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: AppColors
                                                              .primaryColor,
                                                          width: 3.0)),
                                                )
                                                    : const BoxDecoration(),
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 8.0, horizontal: 30.0),
                                                child: Text(
                                                  "Live",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                      fontWeight:
                                                      FontWeight.w800),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isWon = true;
                                                });
                                              },
                                              child: Container(
                                                decoration: isWon
                                                    ? const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: AppColors
                                                              .primaryColor,
                                                          width: 3.0)),
                                                )
                                                    : const BoxDecoration(),
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 8.0, horizontal: 30.0),
                                                child: Text(
                                                  "Won",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                      fontWeight:
                                                      FontWeight.w800),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return "Search field can not be empty!";
                                              }
                                              return null;
                                            },
                                            textInputAction: TextInputAction.done,
                                            cursorColor: AppColors.primaryColor,
                                            keyboardType: TextInputType.text,
                                            style: const TextStyle(fontSize: 16.0),
                                            decoration: InputDecoration(
                                                filled: false,
                                                hintText: "Search Auction",
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: "Montserrat"),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(22),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey.shade200,
                                                      width: 1.0),
                                                ),
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width *
                                              0.03,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                flex:2,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    "Sort By",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(
                                                        fontWeight:
                                                        FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child:
                                                DropdownButtonFormField<String>(
                                                  value: sortByValue,
                                                  isDense: true,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: AppColors.primaryColor),
                                                  isExpanded: true,
                                                  onChanged: (value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      sortByValue = value.toString();
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    filled: false,
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: "Montserrat"),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(22),
                                                      borderSide: BorderSide(
                                                          color:
                                                          Colors.grey.shade200,
                                                          width: 1.0),
                                                    ),
                                                  ),
                                                  items: sortByType
                                                      .map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text(
                                                            value,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyText2!
                                                                .copyWith(
                                                                fontWeight:
                                                                FontWeight.w600),
                                                          ),
                                                        );
                                                      }).toList(),
                                                ),
                                              ),

                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(Icons.refresh)
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  isWon?
                                  BlocProvider<TraderJobsBloc>(
                                    create: (context) => sl()..add(FetchTraderWonAuctionsEvents(userId:  Provider.of<LoginStateProvider>(context,listen: false).getUserId.toString())),
                                    child: const TraderWonAuctionContainer(),
                                  ) : BlocProvider<TraderJobsBloc>(
                                      create: (context) => sl()..add(FetchTraderLiveAuctionsEvents()),
                                      child: const TraderLiveAuctionContainer(),
                                  )
                                ],
                              )),
                        ),
                      ],
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
