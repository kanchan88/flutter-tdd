
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/auth/data/model/user_model.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/data/model/auction_model.dart';
import 'package:workoneerweb/feature/trader/domain/use_case/post_trader_login_usecase.dart' as login;
import 'package:workoneerweb/feature/trader/domain/use_case/post_trader_register_usecase.dart' as register;

// states
class TraderAuthState extends Equatable{
  const TraderAuthState();

  @override
  List<Object> get props => [];
}

class TraderAuthInitialState extends TraderAuthState{

}

class TraderAuthLoadingState extends TraderAuthState{

}

class TraderAuthLoadedState extends TraderAuthState{

  final User user;

  const TraderAuthLoadedState({required this.user});

}

class TraderAuthFailedState extends TraderAuthState{

  final Failure errorText;
  const TraderAuthFailedState({required this.errorText});

}


// events
class TraderAuthEvent extends Equatable {

  @override
  List<Object> get props => [];

}


class TraderAuthLoginEvent extends TraderAuthEvent {

  final String username;
  final String pass;

  TraderAuthLoginEvent({required this.username, required this.pass});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}


class TraderAuthRegisterEvent extends TraderAuthEvent {

  final UserModel user;
  final String pass;

  TraderAuthRegisterEvent({required this.user, required this.pass});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}

class TraderAuthBloc extends Bloc<TraderAuthEvent, TraderAuthState>{


  login.PostTraderLoginUseCase loginUseCase;
  register.PostTraderRegisterUseCase registerUseCase;

  Connectivity connectivity;


  TraderAuthBloc(this.connectivity, this.loginUseCase, this.registerUseCase) : super(TraderAuthInitialState()) {


    void loginTrader(TraderAuthLoginEvent event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit(  const TraderAuthFailedState(errorText: NoInternetConnectionFailure(textMsg: 'No Internet')));

      } else {

        emit ( TraderAuthLoadingState());

        final failureOrTrivia = await loginUseCase(login.Params(username: event.username, pass: event.pass));

        failureOrTrivia.fold((l){
          emit( TraderAuthFailedState(errorText: l));
        }, (r) => emit(TraderAuthLoadedState(user: r),)
        );
      }
    }

    void registerTrader(TraderAuthRegisterEvent event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit(  const TraderAuthFailedState(errorText: NoInternetConnectionFailure(textMsg: 'No Internet')));

      } else {

        emit ( TraderAuthLoadingState());

        final failureOrTrivia = await registerUseCase(register.Params(user: event.user, pass: event.pass));

        failureOrTrivia.fold((l){
          emit( TraderAuthFailedState(errorText: l));
        }, (r) => emit(TraderAuthLoadedState(user: r),)
        );
      }
    }


    on<TraderAuthLoginEvent>(loginTrader);
    on<TraderAuthRegisterEvent>(registerTrader);

  }


}