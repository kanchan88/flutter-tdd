import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/core/widgets/loading_data.dart';
import 'package:workoneerweb/core/widgets/no_data_found.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/bidder_remote_datasource.dart';
import 'package:workoneerweb/feature/client/data/repositories/bidder_repository_impl.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_bidders_for_auction.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/auction_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/widgets/single_auction_card.dart';

class AuctionContainerLive extends StatefulWidget {

  const AuctionContainerLive({ Key? key}) : super(key: key);

  @override
  State<AuctionContainerLive> createState() => _AuctionContainerLiveState();
}

class _AuctionContainerLiveState extends State<AuctionContainerLive> {

  BidderRemoteDataSourceImpl remoteDataSourceImpl = BidderRemoteDataSourceImpl();

  BidderRepositoryImpl? repository;

  GetAllBidderForAuction? liveAuction;

  Connectivity? connectivity;

  @override
  void initState() {

    repository = BidderRepositoryImpl(remoteDataSource: remoteDataSourceImpl);
    liveAuction = GetAllBidderForAuction(repository!);
    connectivity = Connectivity();
    BlocProvider.of<UserJobsBloc>(context).add(FetchLiveAuctionsEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserJobsBloc, AuctionsState>(

      builder: (context, state) {

        if(state is AuctionsLoadingState){
          return SizedBox(
              height: MediaQuery.of(context).size.height*0.78,
              child: const LoadingData(),
          );
        }

        else if (state is AuctionsLoadingErrorState){
          return AlertDialog(
            title: Text(state.errorMessage),
          );
        }

        else if(state is AuctionsLoadedState){
          if(state.allJobs.isEmpty){

            return SizedBox(
              height: MediaQuery.of(context).size.height*0.78,
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
                  return SingleAuctionCard(auctionModel: state.allJobs[index],);
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
