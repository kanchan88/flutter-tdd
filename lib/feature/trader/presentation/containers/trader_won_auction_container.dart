import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workoneerweb/core/provider/login_state_provider.dart';
import 'package:workoneerweb/core/widgets/loading_data.dart';
import 'package:workoneerweb/core/widgets/no_data_found.dart';
import 'package:workoneerweb/feature/auth/presentation/providers/authentication_provider.dart';
import 'package:workoneerweb/feature/trader/presentation/bloc/trader_auction_bloc.dart';
import 'package:workoneerweb/feature/trader/presentation/widgets/single_auction_card_trader.dart';
import '../../../../core/responsive/responsive_ui.dart';
import '../../../../core/responsive/use_mobile_app_dialog.dart';

class TraderWonAuctionContainer extends StatefulWidget {

  const TraderWonAuctionContainer({ Key? key}) : super(key: key);

  @override
  State<TraderWonAuctionContainer> createState() => _TraderWonAuctionContainerState();
}

class _TraderWonAuctionContainerState extends State<TraderWonAuctionContainer> {

  @override
  void initState() {
    BlocProvider.of<TraderJobsBloc>(context).add(FetchTraderWonAuctionsEvents(userId:  Provider.of<LoginStateProvider>(context,listen: false).getUserId.toString()));
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
                child: NoDataFound(msg: "WON AUCTION"),
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
