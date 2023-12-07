
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_single_auction.dart';
import '/feature/client/data/model/auction_model.dart';


// states
class SingleAuctionsState extends Equatable{
  const SingleAuctionsState();

  @override
  List<Object> get props => [];
}

class LoadingSingleAuctionState extends SingleAuctionsState{

}

class LoadedSingleAuctionState extends SingleAuctionsState{

  final AuctionEntity auction;

  const LoadedSingleAuctionState(this.auction);

  @override
  List<Object> get props => [auction];
}

class ErrorLoadingSingleAuctionState extends SingleAuctionsState{

  final String errorMessage;

  const ErrorLoadingSingleAuctionState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class SingleAuctionEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class FetchSingleAuctionEvent extends SingleAuctionEvent {

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}


class SingleAuctionBloc extends Bloc<SingleAuctionEvent, SingleAuctionsState>{

  String id;

  Connectivity connectivity;
  GetSingleAuction singleAuction;


  SingleAuctionBloc(this.id, this.singleAuction, this.connectivity) : super(LoadingSingleAuctionState()) {

    void fetchSingleAuction(event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const ErrorLoadingSingleAuctionState("Internet Connection Lost"));

      } else {
        final failureOrTrivia = await singleAuction(Params(jobId: id));

        failureOrTrivia.fold((l){
          emit( const ErrorLoadingSingleAuctionState("Server Connection Lost"));
        }, (r) => emit(LoadedSingleAuctionState(r))
        );
      }
    }

    on<FetchSingleAuctionEvent>(fetchSingleAuction);

  }


}