import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/core/widgets/loading_data.dart';
import 'package:workoneerweb/core/widgets/no_data_found.dart';
import 'package:workoneerweb/feature/trader/presentation/bloc/trader_auction_bloc.dart';
import 'package:workoneerweb/feature/trader/presentation/widgets/single_auction_card_trader.dart';

import '../../../../core/responsive/responsive_ui.dart';
import '../../../../core/responsive/use_mobile_app_dialog.dart';

class TraderLiveAuctionContainer extends StatefulWidget {

  const TraderLiveAuctionContainer({ Key? key}) : super(key: key);

  @override
  State<TraderLiveAuctionContainer> createState() => _TraderLiveAuctionContainerState();
}

class _TraderLiveAuctionContainerState extends State<TraderLiveAuctionContainer> {

  @override
  void initState() {
    BlocProvider.of<TraderJobsBloc>(context).add(FetchTraderLiveAuctionsEvents());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveUI.isMobile(context)? const UseAppDialog() : BlocBuilder<TraderJobsBloc, TraderAuctionsState>(

      builder: (context, state) {

        if(state is TraderAuctionsLoadingState){
          return SizedBox(
            height: MediaQuery.of(context).size.height*0.7,
            child: const LoadingData(),
          );
        }

        else if (state is TraderAuctionsLoadingErrorState){
          return AlertDialog(
            title: Text(state.errorMessage),
          );
        }

        else if(state is TraderAuctionsLoadedState){

          if(state.allJobs.isEmpty){

            return SizedBox(
              height: MediaQuery.of(context).size.height*0.7,
              child: const Center(
                child: NoDataFound(msg: "LIVE AUCTION"),
              ),
            );

          }


          else{

            return SizedBox(
              height: MediaQuery.of(context).size.height*0.7,
              child: ListView.builder(
                itemCount: state.allJobs.length,
                itemBuilder: (context, index){
                  return SingleAuctionCardTrader(auctionModel: state.allJobs[index],);
                },
              ),
            );

          }
        }

        else{
          return const Text("WENT WRONG. CLOSE THE APP & TRY AGAIN");
        }
      },
    );
  }
}
