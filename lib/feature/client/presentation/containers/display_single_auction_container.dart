
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/configs/app_assets.dart';
import '/configs/app_colors.dart';
import '/core/provider/login_state_provider.dart';
import '/core/responsive/responsive_ui.dart';
import '/core/responsive/use_mobile_app_dialog.dart';
import '/core/screens/display_fulls_screen.dart';
import '/core/screens/vimeo_video_player.dart';
import '/core/widgets/loading_data.dart';
import '/core/widgets/no_data_found.dart';
import '/feature/client/presentation/bloc/bidders_bloc.dart';
import '/feature/client/presentation/bloc/qna_bloc.dart';
import '/feature/client/presentation/bloc/qna_request_bloc.dart';
import '/feature/client/presentation/bloc/single_auction_bloc.dart';
import '/feature/client/presentation/widgets/answer_page.dart';
import '/feature/client/presentation/widgets/bidder_details_card.dart';
import '/injection_container.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../trader/presentation/common/un_autenticated_view.dart';


class DisplaySingleLiveAuctionContainer extends StatefulWidget {

  const DisplaySingleLiveAuctionContainer({Key? key}) : super(key: key);

  @override
  State<DisplaySingleLiveAuctionContainer> createState() => _DisplaySingleLiveAuctionContainerState();

}

class _DisplaySingleLiveAuctionContainerState extends State<DisplaySingleLiveAuctionContainer> {

  CarouselController carouselImageController = CarouselController();

  String auctionStatus = 'ENDED';

  String jobId = '';

  @override
  void initState() {

    BlocProvider.of<SingleAuctionBloc>(context).add(FetchSingleAuctionEvent());
    BlocProvider.of<AuctionBidderBloc>(context).add(FetchAllBiddersEvent());

    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return ResponsiveUI.isMobile(context)? const UseAppDialog() : Padding(
      padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.07, vertical: MediaQuery.of(context).size.height*0.05 ),

      child: Provider.of<LoginStateProvider>(context, listen:false).getUserType!=UserType.client ? const UnAuthenticatedView(user: 'client'):

      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          BlocConsumer<SingleAuctionBloc, SingleAuctionsState>(

            listener: (context, state) {
              if(state is LoadedSingleAuctionState){

                setState(() {
                  auctionStatus = state.auction.status.toString();
                  jobId = state.auction.lotNumber.toString();
                });
              }
            },

            builder: (context, state) {

              if(state is LoadingSingleAuctionState){

                return  SizedBox(
                  height: MediaQuery.of(context).size.height*0.78,
                  child: const LoadingData(),
                );

              }

              else if (state is ErrorLoadingSingleAuctionState){
                return AlertDialog(
                  title: Text(state.errorMessage),
                );
              }

              else if(state is LoadedSingleAuctionState){

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

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

                      ],
                    ),

                    state.auction.status=='LIVE' ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.auction.status.toString(), style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 40.0, color: AppColors.primaryColor),),

                        const SizedBox(height: 4.0,),

                        Text("Auction Ends", style: Theme.of(context).textTheme.headline4,),

                        const SizedBox(height: 4.0,),

                        Text("20:00", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppColors.primaryColor,fontWeight: FontWeight.w600),),

                        const SizedBox(height: 4.0,),

                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).goNamed(
                              'chat',
                              params: {'job':state.auction.lotNumber.toString()},
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 20.0
                                  ),
                              ),
                          ),
                          child: const Text(
                              "View Chat",
                              style:TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),

                        )
                      ],
                    ): state.auction.status=='SOON' ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.auction.status.toString(), style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 40.0, color: AppColors.primaryColor),),

                        const SizedBox(height: 4.0,),

                        Text("Auction Starts", style: Theme.of(context).textTheme.headline4,),

                        const SizedBox(height: 4.0,),

                        Text("from 20:00", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppColors.primaryColor,fontWeight: FontWeight.w600),),

                        const SizedBox(height: 4.0,),

                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).goNamed(
                              'chat',
                              params: {'job':state.auction.lotNumber.toString()},
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 20.0
                                  ))),
                          child: const Text(
                              "View Chat",
                              style:TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),

                        )
                      ],
                    ) : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 4.0,),

                        Text("Auction Not Found", style: Theme.of(context).textTheme.headline4,),

                        const SizedBox(height: 4.0,),

                        const Icon(Icons.not_interested, size: 80.0, color: Colors.red,),

                        const SizedBox(height: 4.0,),

                        Text("Auction may be ended \nor it is not live yet.", style: Theme.of(context).textTheme.headline6,),

                      ],
                    ),
                    const SizedBox(width: 10.0,),

                  ],
                );

              }

              else{
                return const Text("WENT WRONG. CLOSE THE APP & TRY AGAIN");
              }
            },
          ),

          SizedBox(height:MediaQuery.of(context).size.height*0.05),

          Container(
            height: 2.0,
            color: Colors.grey.shade300,
          ),

          auctionStatus=='LIVE' || auctionStatus == 'SOON'?
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:MediaQuery.of(context).size.height*0.1),

              Row(
                children: [

                  const Expanded(flex: 1, child: Text(""),),

                  Expanded(flex: 4, child: Text(
                    "All Bids",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  ),

                  const Expanded(flex: 1, child: Text(""),),
                ],
              ),

              BlocConsumer<AuctionBidderBloc, BiddersState>(

                listener: (context, state) async {
                  if(state is BiddersLoadedState){

                    BlocProvider.of<AuctionBidderBloc>(context).add(FetchAllBiddersEvent());

                    await Future.delayed(const Duration(seconds: 5));
                  }
                },

                builder: (context, state) {


                  if (state is BiddersLoadingState) {
                    return const LoadingData();
                  }

                  else if (state is BiddersLoadingErrorState) {
                    return AlertDialog(
                      title: Text(
                          state.errorMessage
                      ),
                    );
                  }

                  else if (state is BiddersLoadedState) {
                    if(state.allBidders.isNotEmpty){
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: ListView.builder(
                          itemCount: state.allBidders.length,
                          itemBuilder: (context, index) {
                            return ShowBiddersWidget(bidderAccountModel: state.allBidders[index], sorting: index,);
                          },
                        ),
                      );
                    }
                    else{
                      return const NoDataFound(msg: "BIDDERS");
                    }
                  } else {
                    return const AlertDialog(
                      title: Text(
                          "Unexpected things happened! Please refresh the page!"
                      ),
                    );
                  }
                },
              ),


              SizedBox(height:MediaQuery.of(context).size.height*0.05),

              Text(
                "Questions From Trades People",
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.start,
              ),

              SizedBox(height:MediaQuery.of(context).size.height*0.02),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.4,
                child: BlocBuilder<QNABloc, QNAState>(
                  builder: (context, state) {

                    BlocProvider.of<QNABloc>(context).add(FetchAllQNAEvents(jobId: jobId));

                    if(state is QNALoadingState){

                      return const LoadingData();

                    }

                    else if ( state is QNALoadedState) {

                      if(state.allQNAs.isEmpty){
                        return const NoDataFound(msg: 'Question/Answer');
                      } else {
                        return ListView.builder(
                            itemCount: state.allQNAs.length,
                            itemBuilder: (context, index){
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)
                                ),
                                child: ExpansionTile(
                                  backgroundColor: Colors.white,
                                  collapsedBackgroundColor: Colors.white,
                                  title: Text(state.allQNAs[index].question['text']),
                                  childrenPadding: const EdgeInsets.all(15.0),
                                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                  expandedAlignment: Alignment.topLeft,
                                  children: [
                                    state.allQNAs[index].answer['text'].toString().isEmpty?
                                    TextButton(
                                      onPressed: (){

                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  BlocProvider<QNARequestBloc>(
                                            create: (context) => sl(),
                                            child: AnswerAuctionQuestions(jobId: jobId, qna: state.allQNAs[index])
                                        ),));
                                      },
                                      child: const Text('Answer', style: TextStyle(color: Colors.white),),
                                    ):
                                    Text(state.allQNAs[index].answer['text'],)
                                  ],

                                ),
                              );
                            }
                        );
                      }

                    }

                    return SizedBox(
                      height: MediaQuery.of(context).size.height*0.1,
                      child: Center(
                        child: TextButton(

                          onPressed: (){

                            BlocProvider.of<QNABloc>(context).add(FetchAllQNAEvents(jobId: jobId));

                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(' Re-Try ', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    );

                  },
                ),
              ),
            ],
          ):Container(height: 0,),

        ],
      ),
    );


  }
}
