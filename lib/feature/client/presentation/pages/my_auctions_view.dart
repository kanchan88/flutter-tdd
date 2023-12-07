import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workoneerweb/core/provider/login_state_provider.dart';
import 'package:workoneerweb/core/responsive/responsive_ui.dart';
import 'package:workoneerweb/core/responsive/use_mobile_app_dialog.dart';
import 'package:workoneerweb/feature/auth/presentation/providers/authentication_provider.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/auction_remote_data_source.dart';
import 'package:workoneerweb/feature/client/data/repositories/auction_repositoy_impl.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_live_auctions.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_review_auctions.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/auction_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/common/header_view.dart';
import 'package:workoneerweb/feature/client/presentation/containers/auction_container_review.dart';
import 'package:workoneerweb/feature/client/presentation/containers/auctions_container.dart';
import 'package:workoneerweb/feature/client/presentation/widgets/sidebar_dashboard.dart';
import 'package:workoneerweb/feature/client/presentation/widgets/my_auctions_add_auction_title.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../trader/presentation/common/un_autenticated_view.dart';
import '/configs/app_colors.dart';

class ShowMyAuctions extends StatefulWidget {
  const ShowMyAuctions({Key? key}) : super(key: key);

  @override
  State<ShowMyAuctions> createState() => _ShowMyAuctionsState();
}

class _ShowMyAuctionsState extends State<ShowMyAuctions> {

  bool isLive = true;
  bool isPending = false;

  List<String> sortByType = ["Date", "Bids", "Status"];

  String sortByValue = "Date";

  AuctionRemoteDataSourceImpl remoteDataSourceImpl = AuctionRemoteDataSourceImpl();

  AuctionRepositoryImpl? repository;

  GetLiveAuction? liveAuction;

  GetReviewAuction? reviewAuction;

  Connectivity? connectivity;



  @override
  void initState() {
    repository = AuctionRepositoryImpl(remoteDataSource: remoteDataSourceImpl);
    liveAuction = GetLiveAuction(repository!);
    reviewAuction = GetReviewAuction(repository!);
    connectivity = Connectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ResponsiveUI.isMobile(context)? const UseAppDialog() : ListView(
        children: [

          const Header(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.07, vertical: MediaQuery.of(context).size.height*0.05 ),
            child: Provider.of<LoginStateProvider>(context, listen:false).getUserType!=UserType.client ? const UnAuthenticatedView(user: 'client'):
            SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: [

                    const MyAuctionsAddAuctionsTitle(),

                    const SizedBox(
                      height: 20.0,
                    ),

                    Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                              flex: 2,
                              child: Sidebar()),
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
                                                    isPending = false;
                                                    isLive = true;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: isLive
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
                                                    isPending = true;
                                                    isLive = false;
                                                  });
                                                },

                                                child: Container(
                                                  decoration: isPending
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
                                                    "Pending",
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
                                                    padding: const EdgeInsets.all(8.0),
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

                                    Container(
                                      color: Colors.white,
                                      height: MediaQuery.of(context).size.height*0.7,
                                      child: MultiBlocProvider(
                                          providers: [
                                                BlocProvider(create: (context) => UserJobsBloc( Provider.of<LoginStateProvider>(context,listen: false).getUserId.toString(), liveAuction!, reviewAuction!, connectivity!),),
                                          ],
                                          child: isLive? const AuctionContainerLive():const AuctionContainerReview(),
                                      ),
                                    ),
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
