import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_bidders_for_auction.dart';


// states
class BiddersState extends Equatable{
  const BiddersState();

  @override
  List<Object> get props => [];
}

class BiddersLoadingState extends BiddersState{

}

class BiddersLoadedState extends BiddersState{

  final List<BidderAccountModel> allBidders;

  const BiddersLoadedState(this.allBidders);

  @override
  List<Object> get props => [allBidders];
}

class BiddersLoadingErrorState extends BiddersState{

  final String errorMessage;

  const BiddersLoadingErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class BiddersEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class FetchAllBiddersEvent extends BiddersEvent {

  @override
  // Equatable class needs to override props method
  List<BidderAccountModel> get props => [];
}


class AuctionBidderBloc extends Bloc<BiddersEvent, BiddersState>{

  String id;
  GetAllBidderForAuction getBidder;
  Connectivity connectivity;


  AuctionBidderBloc(this.id, this.getBidder, this.connectivity) : super(BiddersLoadingState()) {

    void fetchBidder(event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const BiddersLoadingErrorState("Internet Connection Lost"));

      } else {
        final failureOrTrivia = await getBidder(Params(jobId: id));

        failureOrTrivia.fold((l){
          emit(const BiddersLoadingErrorState("Server Connection Lost"));
        }, (r) {
          r.sort((a, b) => a.bidAmount.compareTo(b.bidAmount));
          emit(BiddersLoadedState(r));
        }
        );
      }
    }

    on<FetchAllBiddersEvent>(fetchBidder);


  }


}