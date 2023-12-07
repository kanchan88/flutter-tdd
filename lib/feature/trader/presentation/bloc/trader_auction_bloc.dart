import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/model/auction_model.dart';
import 'package:workoneerweb/feature/client/domain/entities/auction_entity.dart';
import 'package:workoneerweb/feature/trader/domain/use_case/get_traders_live_auctions.dart';
import 'package:workoneerweb/feature/trader/domain/use_case/get_traders_won_auctions.dart';


// states
class TraderAuctionsState extends Equatable{
  const TraderAuctionsState();

  @override
  List<Object> get props => [];
}

class TraderAuctionsLoadingState extends TraderAuctionsState{

}

class TraderAuctionsLoadedState extends TraderAuctionsState{

  final List<AuctionEntity> allJobs;

  const TraderAuctionsLoadedState(this.allJobs);

  @override
  List<Object> get props => [allJobs];
}

class TraderAuctionsLoadingErrorState extends TraderAuctionsState{

  final String errorMessage;

  const TraderAuctionsLoadingErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class TraderAuctionsEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class FetchTraderLiveAuctionsEvents extends TraderAuctionsEvent {

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}

class FetchTraderWonAuctionsEvents extends TraderAuctionsEvent {

  final String userId;

  FetchTraderWonAuctionsEvents({required this.userId});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}



class TraderJobsBloc extends Bloc<TraderAuctionsEvent, TraderAuctionsState>{


  GetTraderLiveAuction getTraderLiveAuction;
  GetTraderWonAuction getTraderWonAuction;

  TraderJobsBloc(this.getTraderLiveAuction, this.getTraderWonAuction) : super(TraderAuctionsLoadingState()) {

    void fetchLiveAuctions(event, emit) async {

      try {

        final failureOrTrivia = await getTraderLiveAuction();

        failureOrTrivia.fold((l){
          emit( const TraderAuctionsLoadingErrorState("Server Connection Lost"));
        }, (r) => emit(TraderAuctionsLoadedState(r))
        );

      } catch (e) {
        emit( const TraderAuctionsLoadingErrorState("Server Connection Lost"));
      }
    }

    void fetchWonAuctions(FetchTraderWonAuctionsEvents event, emit) async {

      try {

        final failureOrAuctions = await getTraderWonAuction(Params(userId: event.userId));

        failureOrAuctions.fold((l){
          emit( const TraderAuctionsLoadingErrorState("Server Connection Lost"));
        }, (r) => emit(TraderAuctionsLoadedState(r))
        );

      } catch (e) {
        emit( const TraderAuctionsLoadingErrorState("Something unexpected happened!"));
      }
    }

    on<FetchTraderLiveAuctionsEvents>(fetchLiveAuctions);
    on<FetchTraderWonAuctionsEvents>(fetchWonAuctions);



  }


}