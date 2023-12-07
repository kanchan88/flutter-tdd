import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_bidders_for_auction.dart';


// states
class TraderBiddersState extends Equatable{
  const TraderBiddersState();

  @override
  List<Object> get props => [];
}

class TraderBiddersLoadingState extends TraderBiddersState{

}

class TraderBiddersLoadedState extends TraderBiddersState{

  final List<BidderAccountModel> allBidders;

  const TraderBiddersLoadedState(this.allBidders);

  @override
  List<Object> get props => [allBidders];
}

class TraderBiddersLoadingErrorState extends TraderBiddersState{

  final String errorMessage;

  const TraderBiddersLoadingErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class TradersBiddersEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class FetchAllTraderBiddersEvent extends TradersBiddersEvent {

  @override
  // Equatable class needs to override props method
  List<BidderAccountModel> get props => [];
}


class TraderAuctionBidderBloc extends Bloc<TradersBiddersEvent, TraderBiddersState>{

  String id;
  GetAllBidderForAuction getBidder;
  Connectivity connectivity;


  TraderAuctionBidderBloc(this.id, this.getBidder, this.connectivity) : super(TraderBiddersLoadingState()) {

    void fetchBidder(event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const TraderBiddersLoadingErrorState("Internet Connection Lost"));

      } else {
        final failureOrTrivia = await getBidder(Params(jobId: id));

        failureOrTrivia.fold((l){
          emit(const TraderBiddersLoadingErrorState("Server Connection Lost"));
        }, (r) => emit(TraderBiddersLoadedState(r))
        );
      }
    }

    on<FetchAllTraderBiddersEvent>(fetchBidder);


  }


}