
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/trader/domain/use_case/get_client_details_use_case.dart';
import '/feature/client/data/model/auction_model.dart';


// states
class ClientDetailsState extends Equatable{
  const ClientDetailsState();

  @override
  List<Object> get props => [];
}

class LoadingClientDetailsState extends ClientDetailsState{

}

class LoadedClientDetailsState extends ClientDetailsState{

  final User user;

  const LoadedClientDetailsState(this.user);

  @override
  List<Object> get props => [user];
}

class ErrorLoadingClientDetailsState extends ClientDetailsState{

  final String errorMessage;

  const ErrorLoadingClientDetailsState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class ClientDetailEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class FetchClientDetailsEvent extends ClientDetailEvent {

  final String clientId;

  FetchClientDetailsEvent({required this.clientId});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}


class ClientDetailBloc extends Bloc<ClientDetailEvent, ClientDetailsState>{

  Connectivity connectivity;
  GetClientDetailsUseCase clientDetailsUseCase;


  ClientDetailBloc(this.clientDetailsUseCase, this.connectivity) : super(LoadingClientDetailsState()) {

    void fetchClientInfo(FetchClientDetailsEvent event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const ErrorLoadingClientDetailsState("Internet Connection Lost"));

      } else {
        final failureOrTrivia = await clientDetailsUseCase(Params(userId: event.clientId));

        failureOrTrivia.fold((l){
          emit( const ErrorLoadingClientDetailsState("Server Connection Lost"));
        }, (r) => emit(LoadedClientDetailsState(r))
        );
      }
    }

    on<FetchClientDetailsEvent>(fetchClientInfo);

  }


}