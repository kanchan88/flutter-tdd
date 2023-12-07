import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/trader/domain/use_case/post_place_bid_usecase.dart';


// states
class TraderPlaceBidState extends Equatable{
  const TraderPlaceBidState();

  @override
  List<Object> get props => [];
}

class TraderPlaceBidLoading extends TraderPlaceBidState{

}

class TraderPlaceBidInitial extends TraderPlaceBidState{

}

class TraderPlaceBidSuccess extends TraderPlaceBidState{

  final bool success;

  const TraderPlaceBidSuccess(this.success);

  @override
  List<Object> get props => [success];
}

class TraderPlaceBidFailed extends TraderPlaceBidState{

  final String errorMessage;

  const TraderPlaceBidFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class TraderPlaceBidEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class TraderPostPlaceBid extends TraderPlaceBidEvent {

  final String jobId;
  final int bidAmount;
  final BidderAccountModel bidder;

  TraderPostPlaceBid({required this.jobId, required this.bidAmount, required this.bidder});

  @override
  // Equatable class needs to override props method
  List<BidderAccountModel> get props => [];
}


class TraderPlaceBidBloc extends Bloc<TraderPlaceBidEvent, TraderPlaceBidState>{

  PlaceBidUseCase placeBid;
  Connectivity connectivity;

  TraderPlaceBidBloc({required this.placeBid, required this.connectivity}) : super(TraderPlaceBidInitial()) {

    void makeBid(TraderPostPlaceBid event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const TraderPlaceBidFailed("Internet Connection Lost"));

      } else {

        emit(TraderPlaceBidLoading());

        final failureOrTrivia = await placeBid(Params(jobId: event.jobId, amount: event.bidAmount , bidder:event.bidder));

        failureOrTrivia.fold((l){
          emit(const TraderPlaceBidFailed("Server Connection Lost"));
        }, (r) => emit(TraderPlaceBidSuccess(r))
        );
      }
    }

    on<TraderPostPlaceBid>(makeBid);


  }


}