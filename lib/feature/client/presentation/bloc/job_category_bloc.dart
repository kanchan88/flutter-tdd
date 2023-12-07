
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/model/auction_model.dart';
import 'package:workoneerweb/feature/client/domain/entities/job_category_entity.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_job_categories.dart';


// states
class JobCategoryState extends Equatable{
  const JobCategoryState();

  @override
  List<Object> get props => [];
}

class LoadingJobCategoryState extends JobCategoryState{

}

class StartJobCategoryState extends JobCategoryState{

}

class LoadedJobCategoryState extends JobCategoryState{

  final List<JobCategoryEntity> allJobs;

  const LoadedJobCategoryState(this.allJobs);

  @override
  List<Object> get props => [allJobs];
}

class ErrorJobCategoryState extends JobCategoryState{

  final String errorMessage;

  const ErrorJobCategoryState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class JobCategoryEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class FetchJobCategoryEvents extends JobCategoryEvent {

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}


class JobCategoryBloc extends Bloc<JobCategoryEvent, JobCategoryState>{

  GetJobCategories jobCategories;
  Connectivity connectivity;

  JobCategoryBloc({required this.connectivity, required this.jobCategories}) : super(LoadingJobCategoryState()) {

    void fetchJobCategories(event, emit) async {

      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit(const ErrorJobCategoryState("Internet Connection Lost"));

      } else {

        final failureOrTrivia = await jobCategories();

        failureOrTrivia.fold((l){
          emit( const ErrorJobCategoryState("Server Connection Lost"));
          }, (r){
          emit(LoadedJobCategoryState(r));
        }
        );
      }
    }

    on<FetchJobCategoryEvents>(fetchJobCategories);

  }


}