
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/model/auction_model.dart';
import 'package:workoneerweb/feature/client/domain/entities/qna_entity.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_qna_usecase.dart';


// states
class QNAState extends Equatable{
  const QNAState();

  @override
  List<Object> get props => [];
}

class QNALoadingState extends QNAState{

}


class QNALoadedState extends QNAState{

  final List<QNAEntity> allQNAs;

  const QNALoadedState(this.allQNAs);

  @override
  List<Object> get props => [allQNAs];
}

class QNALoadingErrorState extends QNAState{

  final String errorMessage;

  const QNALoadingErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}


// events
class QNAEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class FetchAllQNAEvents extends QNAEvent {

  final String jobId;

  FetchAllQNAEvents({required this.jobId});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}

class RaiseQuestionEvents extends QNAEvent {

  final String jobId;
  final String questionText;

  RaiseQuestionEvents({required this.jobId, required this.questionText});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}


class ReplyAnswerEvents extends QNAEvent {

  final String jobId;
  final String qnId;
  final String questionText;

  ReplyAnswerEvents({required this.jobId, required this.questionText, required this.qnId});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}

class QNABloc extends Bloc<QNAEvent, QNAState>{

  GetAllQNAUseCase getAllQNAUseCase;

  Connectivity connectivity;


  QNABloc(this.getAllQNAUseCase, this.connectivity) : super(QNALoadingState()) {

    void fetchLiveAuctions(FetchAllQNAEvents event, emit) async {
      ConnectivityResult connectivityResult = await connectivity
          .checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        emit(const QNALoadingErrorState("Internet Connection Lost"));
      } else {
        final failureOrTrivia = await getAllQNAUseCase(
            Params(jobId: event.jobId));

        failureOrTrivia.fold((l) {
          emit(const QNALoadingErrorState("Server Connection Lost"));
        }, (r) => emit(QNALoadedState(r),)
        );
      }
    }

    on<FetchAllQNAEvents>(fetchLiveAuctions);

  }


}