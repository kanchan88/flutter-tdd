import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/trader/domain/use_case/post_reset_trader_pass_usecase.dart' as reset;
import 'package:workoneerweb/feature/trader/domain/use_case/post_update_trader_usecase.dart' as update;


// states
class TraderUpdateState extends Equatable{
  const TraderUpdateState();

  @override
  List<Object> get props => [];
}

class TraderPassLoading extends TraderUpdateState{

}

class TraderUpdateLoading extends TraderUpdateState{

}

class TraderUpdateInitial extends TraderUpdateState{

}

class TraderPassInitial extends TraderUpdateState{

}

class TraderUpdateSuccess extends TraderUpdateState{

  final User user;

  const TraderUpdateSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class TraderPassResetSuccess extends TraderUpdateState{

  final bool status;

  const TraderPassResetSuccess(this.status);

  @override
  List<Object> get props => [status];
}

class TraderUpdateFailed extends TraderUpdateState{

  final String errorMessage;

  const TraderUpdateFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class TraderUpdateEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class TraderPostUpdate extends TraderUpdateEvent {

  final String userId;
  final String name;
  final String phone;

  TraderPostUpdate({required this.userId, required this.name, required this.phone});

  @override
  // Equatable class needs to override props method
  List<BidderAccountModel> get props => [];
}

class TraderPostResetPassword extends TraderUpdateEvent {

  final String userId;
  final String newPass;

  TraderPostResetPassword({required this.userId, required this.newPass});

  @override
  // Equatable class needs to override props method
  List<BidderAccountModel> get props => [];
}


class TraderAccountUpdateBloc extends Bloc<TraderUpdateEvent, TraderUpdateState>{

  update.PostTraderUpdateUseCase traderUpdateUseCase;
  reset.PostTraderResetPassUseCase resetPassUseCase;
  Connectivity connectivity;

  TraderAccountUpdateBloc({required this.traderUpdateUseCase, required this.resetPassUseCase, required this.connectivity}) : super(TraderUpdateInitial()) {

    void updateAccount(TraderPostUpdate event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const TraderUpdateFailed("Internet Connection Lost"));

      } else {

        emit(TraderUpdateLoading());

        final failureOrTrivia = await traderUpdateUseCase(update.Params(userId: event.userId, name: event.name , phone:event.phone));

        failureOrTrivia.fold((l){
          emit(const TraderUpdateFailed("Server Connection Lost"));
        }, (r) => emit(TraderUpdateSuccess(r))
        );
      }
    }

    void resetPass(TraderPostResetPassword event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const TraderUpdateFailed("Internet Connection Lost"));

      } else {

        emit(TraderPassLoading());

        final failureOrTrivia = await resetPassUseCase(reset.Params(userId: event.userId, password: event.newPass));

        failureOrTrivia.fold((l){
          emit(const TraderUpdateFailed("Server Connection Lost"));
        }, (r) => emit(TraderPassResetSuccess(r))
        );
      }
    }

    on<TraderPostUpdate>(updateAccount);
    on<TraderPostResetPassword>(resetPass);

  }


}