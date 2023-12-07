import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/configs/app_assets.dart';
import '/configs/app_colors.dart';
import '/core/responsive/responsive_ui.dart';
import '/core/responsive/use_mobile_app_dialog.dart';
import '/core/screens/display_fulls_screen.dart';
import '/core/screens/vimeo_video_player.dart';
import '/core/widgets/loading_data.dart';
import '/core/widgets/no_data_found.dart';
import '/feature/client/presentation/bloc/qna_bloc.dart';
import '/feature/client/presentation/bloc/single_auction_bloc.dart';
import '../../../../core/provider/login_state_provider.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../trader/presentation/common/un_autenticated_view.dart';


class DisplaySingleReviewAuctionContainer extends StatefulWidget {
  const DisplaySingleReviewAuctionContainer({Key? key}) : super(key: key);

  @override
  State<DisplaySingleReviewAuctionContainer> createState() => _DisplaySingleReviewAuctionContainerState();
}

class _DisplaySingleReviewAuctionContainerState extends State<DisplaySingleReviewAuctionContainer> {

  CarouselController carouselImageController = CarouselController();
  String jobId = "";


  @override
  void initState() {
    BlocProvider.of<SingleAuctionBloc>(context).add(FetchSingleAuctionEvent());
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
                jobId = state.auction.lotNumber.toString();
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

                return Column(

                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  const SizedBox(height: 8.0,),

                                  Text("Construction Worker", style: Theme.of(context).textTheme.headline4,),

                                  const SizedBox(height: 4.0,),

                                  Row(
                                    children: [
                                      const Icon(Icons.add, color: AppColors.primaryColor,),

                                      Text("Add more", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppColors.primaryColor, decoration: TextDecoration.underline,),)
                                    ],
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
                                  ),
                                  const SizedBox(height: 8.0,),

                                  Row(
                                    children: [
                                      const Icon(Icons.refresh, color: AppColors.primaryColor,),

                                      Text("Recreate", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppColors.primaryColor, decoration: TextDecoration.underline,),)
                                    ],
                                  ),

                                  Text("", style: Theme.of(context).textTheme.headline4,),

                                  const SizedBox(height: 4.0,),
                                ],
                              ),
                            ),

                          ],
                        ),

                        state.auction.status=='LIVE'?
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('THIS AUCTION IS LIVE', style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 20.0, color: AppColors.primaryColor),),

                              const SizedBox(height: 4.0,),

                              TextButton(
                                onPressed: () {

                                  GoRouter.of(context).goNamed(
                                    'live-auction',
                                    params: {'id':state.auction.lotNumber.toString()},
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
                                    "View Live",
                                    style:TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),

                              ),
                            ],
                          ),
                        ):
                        state.auction.reviewGrade!=null?
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(state.auction.reviewGrade.toString(), style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 60.0, color: AppColors.primaryColor),),

                                  const SizedBox(height: 4.0,),

                                  Text("Your Video Got ${state.auction.reviewGrade}", style: Theme.of(context).textTheme.headline4,),

                                  const SizedBox(height: 4.0,),

                                  TextButton(
                                    onPressed: () {},
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
                            ):
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Text("", style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 60.0, color: AppColors.primaryColor),),

                              const SizedBox(height: 4.0,),

                              Text("Under Review", style: Theme.of(context).textTheme.headline3,),

                              const SizedBox(height: 4.0,),

                              Text("Please Wait! Your auction is still under review.", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppColors.primaryColor,fontWeight: FontWeight.w600),),

                              const SizedBox(height: 4.0,),

                              TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20.0))),
                                    child: const Text(
                                      "View Chat",
                                      style:TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6.0,),
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

                        const Expanded(
                          flex: 2,
                          child: Text(''),
                        ),

                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [


                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Latest Video",
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: AppColors.primaryColor),
                                ),
                              ),

                              Image.asset(AppAssets.videoPlayImage, width: MediaQuery.of(context).size.width*0.5,),


                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "This video was grade ",
                                      style: Theme.of(context).textTheme.headline4,
                                    ),
                                    Text(
                                      state.auction.reviewGrade.toString(),
                                      style: Theme.of(context).textTheme.headline3!.copyWith(color: AppColors.primaryColor),
                                    ),
                                  ],
                                ),
                              ),


                              state.auction.reviewGrade!=null

                                  ?   Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Container(
                                            height: 2.0,
                                            color: Colors.grey.shade300,
                                          ),

                                          SizedBox(height: MediaQuery.of(context).size.height*0.02),

                                          Text("To upgrade this into “B” you’ll need to complete the tasks:", style: Theme.of(context).textTheme.headline4!.copyWith(color: AppColors.primaryColor, fontSize: 16.0),),

                                          SizedBox(height: MediaQuery.of(context).size.height*0.01),

                                          Text("Upgrading Progress", style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14.0),),

                                          const ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            child: LinearProgressIndicator(
                                              value: 8/10,
                                              backgroundColor: AppColors.primaryColorOff,
                                              minHeight: 6.0,
                                            ),
                                          ),

                                          SizedBox(height: MediaQuery.of(context).size.height*0.01),

                                          SizedBox(
                                            height: MediaQuery.of(context).size.height*0.2,
                                            child: ListView.builder(
                                              itemCount: state.auction.reviewResponse!.length,
                                              itemBuilder: (context, index){
                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Icon(Icons.error_outline, color: Colors.red,),
                                                      const SizedBox(width: 15.0,),
                                                      Expanded(child: Text(state.auction.reviewResponse![index]))
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.3,
                                                  child: TextButton(
                                                    onPressed: () {},
                                                    style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                                                        shape: MaterialStateProperty.all(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(4))),
                                                        padding: MaterialStateProperty.all(
                                                            const EdgeInsets.symmetric(
                                                                horizontal: 20.0, vertical: 6.0
                                                            ))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                                      child: Text(
                                                          "Start Auction",
                                                          style:TextStyle(
                                                              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                                                    ),

                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                              ) : Container(height: 0,),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.3,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4))),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20.0, vertical: 6.0
                                                ))),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                          child: Text(
                                              "Upgrade Video",
                                              style:TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),

                        const Expanded(
                          flex: 2,
                          child: Text(''),
                        ),

                      ],
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
                                          Text(state.allQNAs[index].answer['text'],)
                                        ],

                                      ),
                                    );
                                  }
                              );
                            }

                          }



                          return TextButton(
                            onPressed: (){

                              BlocProvider.of<QNABloc>(context).add(FetchAllQNAEvents(jobId: jobId));

                            },
                            child: const Text('Re-Try', style: TextStyle(color: Colors.white),),
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
