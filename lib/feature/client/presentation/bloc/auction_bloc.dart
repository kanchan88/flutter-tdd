
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/model/auction_model.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_live_auctions.dart' as live;
import 'package:workoneerweb/feature/client/domain/usecase/get_review_auctions.dart' as pending;


// states
class AuctionsState extends Equatable{
  const AuctionsState();

  @override
  List<Object> get props => [];
}

class AuctionsLoadingState extends AuctionsState{

}

class AuctionsLoadedState extends AuctionsState{

  final List<AuctionEntity> allJobs;

  const AuctionsLoadedState(this.allJobs);

  @override
  List<Object> get props => [allJobs];
}

class AuctionsLoadingErrorState extends AuctionsState{

  final String errorMessage;

  const AuctionsLoadingErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class AuctionsEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class FetchLiveAuctionsEvents extends AuctionsEvent {

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}


class FetchReviewAuctionsEvents extends AuctionsEvent {

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}

class UserJobsBloc extends Bloc<AuctionsEvent, AuctionsState>{

  String id;
  live.GetLiveAuction getLiveAuction;
  pending.GetReviewAuction getReviewAuction;
  Connectivity connectivity;


  UserJobsBloc(this.id, this.getLiveAuction, this.getReviewAuction, this.connectivity) : super(AuctionsLoadingState()) {

    void fetchLiveAuctions(event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const AuctionsLoadingErrorState("Internet Connection Lost"));

      } else {
        final failureOrTrivia = await getLiveAuction(live.Params(userId: id));

        failureOrTrivia.fold((l){
          emit( const AuctionsLoadingErrorState("Server Connection Lost"));
        }, (r) => emit(AuctionsLoadedState(r))
        );
      }
    }

    void fetchReviewAuctions(event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const AuctionsLoadingErrorState("Internet Connection Lost"));

      } else {
        final failureOrTrivia = await getReviewAuction(pending.Params(userId: id));

        failureOrTrivia.fold((l){
          emit( const AuctionsLoadingErrorState("Server Connection Lost"));
        }, (r) => emit(AuctionsLoadedState(r))
        );
      }
    }

    on<FetchLiveAuctionsEvents>(fetchLiveAuctions);
    on<FetchReviewAuctionsEvents>(fetchReviewAuctions);


  }


}