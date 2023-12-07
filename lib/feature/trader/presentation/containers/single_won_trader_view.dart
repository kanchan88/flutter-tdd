
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workoneerweb/configs/app_assets.dart';
import 'package:workoneerweb/core/provider/login_state_provider.dart';
import 'package:workoneerweb/core/screens/display_fulls_screen.dart';
import 'package:workoneerweb/core/screens/vimeo_video_player.dart';
import 'package:workoneerweb/core/widgets/loading_data.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/single_auction_bloc.dart';
import 'package:workoneerweb/feature/trader/presentation/common/un_autenticated_view.dart';
import 'package:workoneerweb/feature/trader/presentation/widgets/show_client_details.dart';

import '../../../../core/responsive/responsive_ui.dart';
import '../../../../core/responsive/use_mobile_app_dialog.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/authentication_provider.dart';


class SingleWonTraderView extends StatefulWidget {
  const SingleWonTraderView({Key? key}) : super(key: key);

  @override
  State<SingleWonTraderView> createState() => _SingleWonTraderViewState();
}

class _SingleWonTraderViewState extends State<SingleWonTraderView> {

  CarouselController carouselImageController = CarouselController();
  TextEditingController bidAmt = TextEditingController(text: '10');

  String jobId = '';

  @override
  void initState() {
    BlocProvider.of<SingleAuctionBloc>(context).add(FetchSingleAuctionEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return ResponsiveUI.isMobile(context)? const UseAppDialog() : Padding(
      padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.07, vertical: MediaQuery.of(context).size.height*0.05 ),
      child: Provider.of<LoginStateProvider>(context, listen:false).getUserType!=UserType.trader ? const UnAuthenticatedView(user: 'trader'):
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          BlocConsumer<SingleAuctionBloc, SingleAuctionsState>(

            listener: (context, state) {
              if(state is LoadedSingleAuctionState){
                jobId = state.auction.lotNumber.toString();
              }
            },

            builder: (context, state) {

              if(state is LoadingSingleAuctionState){

                return  SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const LoadingData(),
                );

              }

              else if (state is ErrorLoadingSingleAuctionState){
                return AlertDialog(
                  title: Text(state.errorMessage),
                );
              }

              else if(state is LoadedSingleAuctionState){

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Main Job", style: Theme.of(context).textTheme.headline4,),
                              const SizedBox(height: 4.0,),
                              Container(
                                width: MediaQuery.of(context).size.width*0.3,
                                height: MediaQuery.of(context).size.height*0.4,
                                color:Colors.white,
                                child: state.auction.images!.isEmpty?
                                Image.asset(AppAssets.noImage, fit: BoxFit.contain,):
                                CarouselSlider(
                                    items: state.auction.images!.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DisplayImageFullScreen(
                                                          images: state.auction.images!,
                                                          clickedImage: i,
                                                        ),
                                                  ));
                                            },
                                            child: Stack(
                                              children: [
                                                Hero(
                                                  tag: "enlargeImage",
                                                  child: SizedBox(
                                                    width: MediaQuery.of(context).size.width *
                                                        0.3,
                                                    child: SizedBox(
                                                      height: MediaQuery.of(context).size.height * 0.4,
                                                      child: Image.network(i, fit: BoxFit.contain,),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  bottom: MediaQuery.of(context).size.height * 0.15,
                                                  child: InkWell(
                                                    onTap: () {
                                                      carouselImageController.nextPage();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                          BorderRadius.circular(50.0),
                                                        ),
                                                        child: const Icon(
                                                          Icons.chevron_right,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 0,
                                                  bottom:
                                                  MediaQuery.of(context).size.height * 0.15,
                                                  child: InkWell(
                                                    onTap: () {
                                                      carouselImageController
                                                          .previousPage();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                            BorderRadius.circular(50.0),
                                                          ),
                                                          child: const Icon(
                                                            Icons.chevron_left,
                                                            size: 30,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                    carouselController: carouselImageController,
                                    options: CarouselOptions(
                                      height: 400,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 1,
                                      initialPage: 0,
                                      reverse: false,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: false,
                                      scrollDirection: Axis.horizontal,
                                    )),
                              )
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Selfie Job", style: Theme.of(context).textTheme.headline4,),
                              const SizedBox(height: 4.0,),
                              Container(
                                width: MediaQuery.of(context).size.width*0.3,
                                height: MediaQuery.of(context).size.height*0.4,
                                color:Colors.white,
                                child: VimeoVideoPlayer(viewID: state.auction.selfieVideoId.toString(),),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.05),

                    Container(
                      height: 2.0,
                      color: Colors.grey.shade300,
                    ),

                    SizedBox(height:MediaQuery.of(context).size.height*0.05),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("CLIENT DETAILS", style: TextStyle(fontSize: 22, fontFamily: "Marcellus"),),
                      ],
                    ),

                    SizedBox(height:MediaQuery.of(context).size.height*0.05),

                    state.auction.status!="ENDED"
                        ? const Text("Auction is not ended! You can only view when ended") :
                            state.auction.winnerId!=Provider.of<AuthenticationProvider>(context,listen: false).getUserInfo!.userId
                                ? Text("You are not the winner of auction ${state.auction.lotNumber}"):
                                    ShowClientDetails(auction: state.auction),
                  ],
                );

              }

              else{
                return const Text("WENT WRONG. CLOSE THE APP & TRY AGAIN");
              }
            },
          ),

        ],
      ),
    );


  }
}
