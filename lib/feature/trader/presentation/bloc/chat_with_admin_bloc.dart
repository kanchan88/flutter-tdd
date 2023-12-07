import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/trader/domain/use_case/get_all_messages_with_admin_usecase.dart' as get_msg;
import 'package:workoneerweb/feature/trader/domain/use_case/post_send_message_to_admin_usecase.dart';


// states
class AdminMessagesState extends Equatable{
  const AdminMessagesState();

  @override
  List<Object> get props => [];
}


class SendAdminMessagesLoadingState extends AdminMessagesState{

}

class AdminMessagesLoadingState extends AdminMessagesState{

}


class AdminMessagesLoadedState extends AdminMessagesState{

  final List<MessageEntity> allMessages;

  const AdminMessagesLoadedState(this.allMessages);

  @override
  List<Object> get props => [allMessages];
}


class SendAdminMessageSuccessfulState extends AdminMessagesState{

  final List<MessageEntity> allMsgs;

  const SendAdminMessageSuccessfulState(this.allMsgs);

  @override
  List<Object> get props => [allMsgs];
}

class AdminMessagesLoadingErrorState extends AdminMessagesState{

  final String errorMessage;

  const AdminMessagesLoadingErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class AdminMessagesEvent extends Equatable {

  @override
  List<Object> get props => [];

}



class FetchAllMessagesWithAdminEvent extends AdminMessagesEvent {

  final String jobId;
  final String traderId;

  FetchAllMessagesWithAdminEvent({required this.jobId, required this.traderId});

  @override
  // Equatable class needs to override props method
  List<BidderAccountModel> get props => [];
}


class SendMessageToAdminEvent extends AdminMessagesEvent {

  final String jobId;
  final String traderId;
  final String message;

  SendMessageToAdminEvent({required this.jobId, required this.traderId, required this.message});

  @override
  // Equatable class needs to override props method
  List<BidderAccountModel> get props => [];
}


class AdminMessagesBloc extends Bloc<AdminMessagesEvent, AdminMessagesState>{

  get_msg.GetAllMessagesWithAdminUseCase getAllMessagesUseCase;
  PostSendMessageToAdminUseCase sendMessageToAdminUseCase;
  Connectivity connectivity;


  AdminMessagesBloc({required this.getAllMessagesUseCase, required this.sendMessageToAdminUseCase, required this.connectivity}) : super(AdminMessagesLoadingState()) {

    void fetchMsgWithAdmin(FetchAllMessagesWithAdminEvent event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const AdminMessagesLoadingErrorState("Internet Connection Lost"));

      } else {
        final failureOrTrivia = await getAllMessagesUseCase(get_msg.Params(jobId: event.jobId , traderId: event.traderId));

        failureOrTrivia.fold((l){
          emit(const AdminMessagesLoadingErrorState("Server Connection Lost"));
        }, (r) {
          r.sort((b, a) => a.timestamp.compareTo(b.timestamp));
          emit(AdminMessagesLoadedState(r));
        }
        );
      }
    }


    void sendMessageToAdmin(SendMessageToAdminEvent event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const AdminMessagesLoadingErrorState("Internet Connection Lost"));

      } else {

        final failureOrTrivia = await sendMessageToAdminUseCase(Params(jobId: event.jobId, traderId: event.traderId, message: event.message));

        failureOrTrivia.fold((l){
          emit(const AdminMessagesLoadingErrorState("Server Connection Lost"));
        }, (r) {
          r.sort((b, a) => a.timestamp.compareTo(b.timestamp));
          emit(AdminMessagesLoadedState(r));

        }
        );
      }
    }

    on<FetchAllMessagesWithAdminEvent>(fetchMsgWithAdmin);

    on<SendMessageToAdminEvent>(sendMessageToAdmin);

  }


}