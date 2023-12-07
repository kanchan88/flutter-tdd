import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/client/data/model/bidder_account_model.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_messages_usecase.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_sender_usecase.dart' as sender;
import 'package:workoneerweb/feature/client/domain/usecase/post_send_message_to_trader.dart' as trader;


// states
class MessagesState extends Equatable{
  const MessagesState();

  @override
  List<Object> get props => [];
}


class SendMessagesLoadingState extends MessagesState{

}

class MessagesLoadingState extends MessagesState{

}

class SendersLoadingState extends MessagesState{

}

class MessagesLoadedState extends MessagesState{

  final List<MessageEntity> allMessages;

  const MessagesLoadedState(this.allMessages);

  @override
  List<Object> get props => [allMessages];
}

class SendersLoadedState extends MessagesState{

  final List<User> allSenders;

  const SendersLoadedState(this.allSenders);

  @override
  List<Object> get props => [allSenders];
}

class SendMessageSuccessfulState extends MessagesState{

  final List<MessageEntity> allMsgs;

  const SendMessageSuccessfulState(this.allMsgs);

  @override
  List<Object> get props => [allMsgs];
}

class MessagesLoadingErrorState extends MessagesState{

  final String errorMessage;

  const MessagesLoadingErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class MessagesEvent extends Equatable {

  @override
  List<Object> get props => [];

}


class FetchAllSendersEvent extends MessagesEvent {

  final String jobId;

  FetchAllSendersEvent({required this.jobId});

  @override
  // Equatable class needs to override props method
  List<String> get props => [];
}


class FetchAllMessagesEvent extends MessagesEvent {

  final String jobId;
  final String traderId;

  FetchAllMessagesEvent({required this.jobId, required this.traderId});

  @override
  // Equatable class needs to override props method
  List<BidderAccountModel> get props => [];
}


class SendMessageToTraderEvent extends MessagesEvent {

  final String jobId;
  final String traderId;
  final String userId;
  final String message;

  SendMessageToTraderEvent({required this.jobId, required this.traderId, required this.message, required this.userId});

  @override
  // Equatable class needs to override props method
  List<BidderAccountModel> get props => [];
}


class MessagesBloc extends Bloc<MessagesEvent, MessagesState>{

  GetAllMessagesUseCase getAllMessagesUseCase;
  sender.GetAllSenderUseCase getAllSenderUseCase;
  trader.PostSendMessageToTraderUseCase sendMessageToTraderUseCase;
  Connectivity connectivity;


  MessagesBloc({required this.getAllMessagesUseCase, required this.getAllSenderUseCase, required this.connectivity, required this.sendMessageToTraderUseCase}) : super(MessagesLoadingState()) {

    void fetchBidder(FetchAllMessagesEvent event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const MessagesLoadingErrorState("Internet Connection Lost"));

      } else {
        final failureOrTrivia = await getAllMessagesUseCase(Params(jobId: event.jobId , traderId: event.traderId));

        failureOrTrivia.fold((l){
          emit(const MessagesLoadingErrorState("Server Connection Lost"));
        }, (r) {
          r.sort((b, a) => a.timestamp.compareTo(b.timestamp));
          emit(MessagesLoadedState(r));
        }
        );
      }
    }


    void fetchSenders(FetchAllSendersEvent event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const MessagesLoadingErrorState("Internet Connection Lost"));

      } else {
        final failureOrTrivia = await getAllSenderUseCase(sender.Params(jobId: event.jobId));

        failureOrTrivia.fold((l){
          emit(const MessagesLoadingErrorState("Server Connection Lost"));
        }, (r) {
          emit(SendersLoadedState(r));
        }
        );
      }
    }

    void sendMessageToTrader(SendMessageToTraderEvent event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( const MessagesLoadingErrorState("Internet Connection Lost"));

      } else {

        final failureOrTrivia = await sendMessageToTraderUseCase(trader.Params(jobId: event.jobId, traderId: event.traderId, userId: event.userId, message: event.message));

        failureOrTrivia.fold((l){
          emit(const MessagesLoadingErrorState("Server Connection Lost"));
        }, (r) {
          r.sort((b, a) => a.timestamp.compareTo(b.timestamp));
          emit(MessagesLoadedState(r));

        }
        );
      }
    }

    on<FetchAllMessagesEvent>(fetchBidder);

    on<FetchAllSendersEvent>(fetchSenders);

    on<SendMessageToTraderEvent>(sendMessageToTrader);

  }


}