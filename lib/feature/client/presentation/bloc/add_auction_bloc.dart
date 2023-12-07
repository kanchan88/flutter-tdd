
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/model/auction_model.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_auction_usecase.dart';


// states
class AddAuctionsState extends Equatable{
  const AddAuctionsState();

  @override
  List<Object> get props => [];
}

class AddAuctionInitialState extends AddAuctionsState{

}

class AddAuctionLoadingState extends AddAuctionsState{

}

class AddAuctionLoadedState extends AddAuctionsState{

  final bool res;

  const AddAuctionLoadedState(this.res);

  @override
  List<Object> get props => [res];
}

class AddAuctionLoadingErrorState extends AddAuctionsState{

  final String errorMessage;

  const AddAuctionLoadingErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class AddAuctionEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class PostAddAuctionEvent extends AddAuctionEvent {

  final Map auctionData;

  PostAddAuctionEvent({required this.auctionData});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}



class AddAuctionBloc extends Bloc<AddAuctionEvent, AddAuctionsState>{

  PostAuctionUseCase postAuctionUseCase;
  Connectivity connectivity;

  AddAuctionBloc(this.postAuctionUseCase, this.connectivity) : super(AddAuctionInitialState()) {

    void addAuction( PostAddAuctionEvent event, emit) async {

      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const AddAuctionLoadingErrorState("Internet Connection Lost"));

      } else {

        emit( AddAuctionLoadingState());

        final failureOrTrivia = await postAuctionUseCase(Params(auctionInfo: event.auctionData ));

        failureOrTrivia.fold((l){
          emit( const AddAuctionLoadingErrorState("Server Connection Lost"));
        }, (r) => emit(AddAuctionLoadedState(r))
        );
      }
    }

    on<PostAddAuctionEvent>(addAuction);

  }


}