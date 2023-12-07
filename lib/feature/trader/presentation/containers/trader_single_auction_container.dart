
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workoneerweb/configs/app_assets.dart';
import 'package:workoneerweb/configs/app_colors.dart';
import 'package:workoneerweb/core/provider/login_state_provider.dart';
import 'package:workoneerweb/core/screens/display_fulls_screen.dart';
import 'package:workoneerweb/core/screens/vimeo_video_player.dart';
import 'package:workoneerweb/core/widgets/loading_data.dart';
import 'package:workoneerweb/core/widgets/no_data_found.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/bidders_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/qna_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/qna_request_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/single_auction_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/widgets/bidder_details_card.dart';
import 'package:workoneerweb/feature/trader/presentation/bloc/trader_add_bid_bloc.dart';
import 'package:workoneerweb/feature/trader/presentation/common/un_autenticated_view.dart';
import 'package:workoneerweb/feature/trader/presentation/widgets/ask_question_dialog.dart';
import 'package:workoneerweb/injection_container.dart';

import '../../../../core/responsive/responsive_ui.dart';
import '../../../../core/responsive/use_mobile_app_dialog.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/authentication_provider.dart';


class TraderSingleAuctionLiveContainer extends StatefulWidget {
  const TraderSingleAuctionLiveContainer({Key? key}) : super(key: key);

  @override
  State<TraderSingleAuctionLiveContainer> createState() => _TraderSingleAuctionLiveContainerState();
}

class _TraderSingleAuctionLiveContainerState extends State<TraderSingleAuctionLiveContainer> {

  CarouselController carouselImageController = CarouselController();
  TextEditingController bidAmt = TextEditingController(text: '10');

  String jobId = '';

  @override
  void initState() {
    BlocProvider.of<SingleAuctionBloc>(context).add(FetchSingleAuctionEvent());
    BlocProvider.of<AuctionBidderBloc>(context).add(FetchAllBiddersEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return ResponsiveUI.isMobile(context)? const UseAppDialog() :Padding(
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
                              padding: const EdgeInsets.only(left: 10.0),
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

                        state.auction.status=='LIVE'?SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Auction Ends", style: Theme.of(context).textTheme.headline4,),
                              const SizedBox(height: 10.0,),
                              Text("00:15", style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 32.0),),
                              const SizedBox(height: 10.0,),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3.0, color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Latest Bid:", style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14.0), textAlign: TextAlign.start,),
                                      Center(child: Text("\$45", style: Theme.of(context).textTheme.headline5!.copyWith(color: AppColors.primaryColor, fontSize: 36.0, fontWeight: FontWeight.w800), textAlign: TextAlign.center,)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width*0.1,
                                            child: TextFormField(
                                              style: Theme.of(context).textTheme.headline6!
                                                  .copyWith(fontSize: 24, color: AppColors.primaryColor, fontFamily: "Marcellus"),
                                              controller: bidAmt,
                                              validator: (val){
                                                if(val!.isEmpty){
                                                  return "Bid amount can't be empty";
                                                }
                                                else if(int.tryParse(val)==null){
                                                  return "Please use valid number only";
                                                }
                                                else{
                                                  return null;
                                                }
                                              },
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                prefix: Container(
                                                  color: AppColors.primaryColor,
                                                  child: InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        bidAmt.text = "${int.parse(bidAmt.text) + 10}";
                                                      });
                                                    },
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(4.0),
                                                      child: Icon(Icons.add, size: 16, color: Colors.white,),
                                                    ),
                                                  ),
                                                ),
                                                suffix: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 2.0, color: AppColors.primaryColor),
                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                  child: InkWell(
                                                    onTap: (){
                                                      if(int.parse(bidAmt.text)>0){
                                                        setState(() {
                                                          bidAmt.text = "${int.parse(bidAmt.text) - 10}";
                                                        });
                                                      }
                                                      else{
                                                        Fluttertoast.showToast(msg: "Amount can't be < 0");
                                                      }

                                                    },
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(4.0),
                                                      child: Icon(Icons.remove, size: 16, color: AppColors.primaryColor,),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          BlocConsumer<TraderPlaceBidBloc, TraderPlaceBidState>(
                                            listener: (context, state){
                                              if(state is TraderPlaceBidSuccess){
                                                Fluttertoast.showToast(
                                                    msg: 'BID ADDED',
                                                    fontSize: 16.0,
                                                );
                                              }
                                            },
                                            builder: (context, state) {
                                              if(state is TraderPlaceBidInitial || state is TraderPlaceBidSuccess){
                                                return Padding(
                                                  padding: const EdgeInsets.only(left: 4.0),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      BidderAccountModel bidder = BidderAccountModel(id: '120', fullName: 'Ram', bidAmount: 50, date: '', email: 'some@ram.com');
                                                      BlocProvider.of<TraderPlaceBidBloc>(context).add(TraderPostPlaceBid(jobId: jobId, bidAmount: int.parse(bidAmt.text.toString()), bidder: bidder));
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                                                        shape: MaterialStateProperty.all(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(4))),
                                                        padding: MaterialStateProperty.all(
                                                            const EdgeInsets.symmetric(
                                                                horizontal: 4.0
                                                            ))),
                                                    child: const Text(
                                                        "BID",
                                                        style:TextStyle(
                                                            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),

                                                  ),
                                                );
                                              }
                                              else if(state is TraderPlaceBidLoading){
                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: TextButton(
                                                    onPressed: () {},
                                                    style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                                                        shape: MaterialStateProperty.all(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(4))),
                                                        padding: MaterialStateProperty.all(
                                                            const EdgeInsets.symmetric(
                                                                horizontal: 10.0
                                                            ))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(12.0),
                                                      child: CircularProgressIndicator(color: Colors.white,),
                                                    ),

                                                  ),
                                                );
                                              } else {
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      BidderAccountModel bidder = BidderAccountModel(id: '120', fullName: 'Ram', bidAmount: 50, date: '', email: 'some@ram.com');
                                                      BlocProvider.of<TraderPlaceBidBloc>(context).add(TraderPostPlaceBid(jobId: jobId, bidAmount: int.parse(bidAmt.text.toString()), bidder: bidder));
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                                                        shape: MaterialStateProperty.all(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(4))),
                                                        padding: MaterialStateProperty.all(
                                                            const EdgeInsets.symmetric(
                                                                horizontal: 10.0
                                                            ))),
                                                    child: const Text(
                                                        "BID",
                                                        style:TextStyle(
                                                            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),

                                                  ),
                                                );
                                              }
                                              return const Text("ERROR! REFRESH PAGE");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 4.0,),

                              TextButton(
                                onPressed: () {

                                  GoRouter.of(context).goNamed(
                                    'trader-single-chat',
                                    params: {
                                      'job':state.auction.lotNumber.toString(),
                                      'trader': Provider.of<LoginStateProvider>(context, listen: false).getUserId.toString()
                                    },
                                  );

                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10))),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 20.0
                                        ))),
                                child: const Text(
                                    "View Chat",
                                    style:TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),

                              ),
                            ],
                          ),
                        ):state.auction.status=='SOON'?

                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(height: 10.0,),
                              Text("You cannot bid now!", style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16.0),),
                              const SizedBox(height: 10.0,),
                              const Icon(Icons.not_interested, color: Colors.red, size: 80.0,),
                              const SizedBox(height: 10.0,),
                              Text("Auction Starts in 45 sec", style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 14.0),),
                            ],
                          ),
                        ):
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(height: 10.0,),
                              Text("You cannot bid now!", style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16.0),),
                              const SizedBox(height: 10.0,),
                              const Icon(Icons.not_interested, color: Colors.red, size: 80.0,),
                              Text("Wait untill it goes live!", style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 14.0),),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0,),

                      ],
                    ),

                    SizedBox(height:MediaQuery.of(context).size.height*0.05),

                    Container(
                      height: 2.0,
                      color: Colors.grey.shade300,
                    ),

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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Questions From Trades People",
                          style: Theme.of(context).textTheme.headline4,
                        ),

                        TextButton(onPressed: (){

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return BlocProvider<QNARequestBloc>(
                                    create: (context) => sl(),
                                    child:AskQuestionDialog(jobId: jobId)
                                );
                              }
                          );

                        }, child: const Text('Raise Question', style: TextStyle(color: Colors.white),)),
                      ],
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
                                              const Text('NOT ANSWERED YET!'):
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
