
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/auth/data/model/user_model.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/data/model/auction_model.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_client_register_usecase.dart' as register;
import 'package:workoneerweb/feature/client/domain/usecase/post_login_client_usecase.dart' as login;

// states
class ClientAuthState extends Equatable{
  const ClientAuthState();

  @override
  List<Object> get props => [];
}

class ClientAuthInitialState extends ClientAuthState{

}

class ClientAuthLoadingState extends ClientAuthState{

}

class ClientAuthLoadedState extends ClientAuthState{

  final User user;

  const ClientAuthLoadedState({required this.user});

}

class ClientAuthFailedState extends ClientAuthState{

  final Failure errorText;
  const ClientAuthFailedState({required this.errorText});

}


// events
class ClientAuthEvent extends Equatable {

  @override
  List<Object> get props => [];

}


class ClientAuthLoginEvent extends ClientAuthEvent {

  final String username;
  final String pass;

  ClientAuthLoginEvent({required this.username, required this.pass});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}


class ClientAuthRegisterEvent extends ClientAuthEvent {

  final UserModel user;
  final String pass;

  ClientAuthRegisterEvent({required this.user, required this.pass});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}

class ClientAuthBloc extends Bloc<ClientAuthEvent, ClientAuthState>{


  login.PostClientLoginUseCase loginUseCase;
  register.PostClientRegisterUseCase registerUseCase;

  Connectivity connectivity;


  ClientAuthBloc(this.connectivity, this.loginUseCase, this.registerUseCase) : super(ClientAuthInitialState()) {


    void loginClient(ClientAuthLoginEvent event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit(  const ClientAuthFailedState(errorText: NoInternetConnectionFailure(textMsg: 'No Internet')));

      } else {

        emit ( ClientAuthLoadingState());

        final failureOrTrivia = await loginUseCase(login.Params(username: event.username, pass: event.pass));

        failureOrTrivia.fold((l){
          emit( ClientAuthFailedState(errorText: l));
        }, (r) => emit(ClientAuthLoadedState(user: r),)
        );
      }
    }

    void registerClient(ClientAuthRegisterEvent event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit(  const ClientAuthFailedState(errorText: NoInternetConnectionFailure(textMsg: 'No Internet')));

      } else {

        emit ( ClientAuthLoadingState());

        final failureOrTrivia = await registerUseCase(register.Params(user: event.user, pass: event.pass));

        failureOrTrivia.fold((l){
          emit( ClientAuthFailedState(errorText: l));
        }, (r) {

          emit(ClientAuthLoadedState(user: r),);
        }
        );
      }
    }


    on<ClientAuthLoginEvent>(loginClient);
    on<ClientAuthRegisterEvent>(registerClient);

  }


}