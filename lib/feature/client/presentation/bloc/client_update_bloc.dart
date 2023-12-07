import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_client_reset_pass_usecase.dart' as reset;
import 'package:workoneerweb/feature/client/domain/usecase/post_client_update_use_case.dart';


// states
class ClientUpdateState extends Equatable{
  const ClientUpdateState();

  @override
  List<Object> get props => [];
}

class ClientUpdateLoading extends ClientUpdateState{

}

class ClientPassLoading extends ClientUpdateState{

}

class ClientUpdateInitial extends ClientUpdateState{

}

class ClientUpdateSuccess extends ClientUpdateState{

  final User user;

  const ClientUpdateSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class ClientResetPassSuccess extends ClientUpdateState{

  final bool status;

  const ClientResetPassSuccess(this.status);

  @override
  List<Object> get props => [status];
}

class ClientUpdateFailed extends ClientUpdateState{

  final String errorMessage;

  const ClientUpdateFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class ClientUpdateEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class ClientPostUpdate extends ClientUpdateEvent {

  final String userId;
  final String name;
  final String phone;

  ClientPostUpdate({required this.userId, required this.name, required this.phone});

  @override
  // Equatable class needs to override props method
  List<BidderAccountModel> get props => [];
}

class ClientPostResetPassword extends ClientUpdateEvent {

  final String userId;
  final String newPass;

  ClientPostResetPassword({required this.userId, required this.newPass});

  @override
  // Equatable class needs to override props method
  List<BidderAccountModel> get props => [];
}


class ClientAccountUpdateBloc extends Bloc<ClientUpdateEvent, ClientUpdateState>{

  PostClientUpdateUseCase clientUpdateUseCase;
  reset.PostClientResetPassUseCase passUseCase;
  Connectivity connectivity;

  ClientAccountUpdateBloc({required this.clientUpdateUseCase, required this.passUseCase, required this.connectivity}) : super(ClientUpdateInitial()) {

    void updateAccount(ClientPostUpdate event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const ClientUpdateFailed("Internet Connection Lost"));

      } else {

        emit(ClientUpdateLoading());

        final failureOrTrivia = await clientUpdateUseCase(Params(userId: event.userId, name: event.name , phone:event.phone));

        failureOrTrivia.fold((l){
          emit(const ClientUpdateFailed("Server Connection Lost"));
        }, (r) => emit(ClientUpdateSuccess(r))
        );
      }
    }

    void resetPass(ClientPostResetPassword event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const ClientUpdateFailed("Internet Connection Lost"));

      } else {

        emit(ClientPassLoading());

        final failureOrTrivia = await passUseCase(reset.Params(userId: event.userId, password: event.newPass));

        failureOrTrivia.fold((l){
          emit(const ClientUpdateFailed("Server Connection Lost"));
        }, (r) => emit(ClientResetPassSuccess(r))
        );
      }
    }

    on<ClientPostUpdate>(updateAccount);
    on<ClientPostResetPassword>(resetPass);

  }


}