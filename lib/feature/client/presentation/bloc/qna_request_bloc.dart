
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/model/auction_model.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_question_qna_usecase.dart' as qn;
import 'package:workoneerweb/feature/client/domain/usecase/post_answer_qna_usecase.dart' as ans;


// states
class QNARequestState extends Equatable{
  const QNARequestState();

  @override
  List<Object> get props => [];
}

class QNARequestInitialState extends QNARequestState{

}

class QNARequestLoadingState extends QNARequestState{

}

class QNARequestLoadedState extends QNARequestState{

}

class QNARequestFailedState extends QNARequestState{

}


// events
class QNARequestEvent extends Equatable {

  @override
  List<Object> get props => [];

}


class RaiseQuestionEvents extends QNARequestEvent {

  final String jobId;
  final String questionText;

  RaiseQuestionEvents({required this.jobId, required this.questionText});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}


class ReplyAnswerEvents extends QNARequestEvent {

  final String jobId;
  final String qnId;
  final String questionText;

  ReplyAnswerEvents({required this.jobId, required this.questionText, required this.qnId});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}

class QNARequestBloc extends Bloc<QNARequestEvent, QNARequestState>{

  qn.PostQuestionQNAUseCase questionQNAUseCase;
  ans.PostAnswerQNAUseCase answerQNAUseCase;

  Connectivity connectivity;


  QNARequestBloc(this.connectivity, this.questionQNAUseCase, this.answerQNAUseCase) : super(QNARequestInitialState()) {


    void askQuestion(RaiseQuestionEvents event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( QNARequestFailedState());

      } else {

        emit ( QNARequestLoadingState());

        final failureOrTrivia = await questionQNAUseCase(qn.Params(jobId: event.jobId, text: event.questionText));

        failureOrTrivia.fold((l){
          emit( QNARequestFailedState());
        }, (r) => emit(QNARequestLoadedState(),)
        );
      }
    }

    void sendAnswer(ReplyAnswerEvents event, emit) async {
      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit( QNARequestFailedState());

      } else {

        emit ( QNARequestLoadingState());

        final failureOrTrivia = await answerQNAUseCase(ans.Params(jobId: event.jobId, text: event.questionText, qnId: event.qnId));

        failureOrTrivia.fold((l){
          emit( QNARequestFailedState());
        }, (r) => emit(QNARequestLoadedState(),)
        );
      }
    }


    on<RaiseQuestionEvents>(askQuestion);

    on<ReplyAnswerEvents>(sendAnswer);


  }


}