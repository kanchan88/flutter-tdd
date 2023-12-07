
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/model/auction_model.dart';
import 'package:workoneerweb/feature/client/domain/entities/job_sub_category_entity.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_job_subcategory.dart';


// states
class JobSubCategoryState extends Equatable{
  const JobSubCategoryState();

  @override
  List<Object> get props => [];
}

class LoadingJobSubCategoryState extends JobSubCategoryState{

}

class StartJobSubCategoryState extends JobSubCategoryState{

}

class LoadedJobSubCategoryState extends JobSubCategoryState{

  final List<JobSubCategoryEntity> allSubJobs;

  const LoadedJobSubCategoryState(this.allSubJobs);

  @override
  List<Object> get props => [allSubJobs];
}

class ErrorJobSubCategoryState extends JobSubCategoryState{

  final String errorMessage;

  const ErrorJobSubCategoryState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

}

// events
class JobSubCategoryEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class FetchJobSubCategoryEvents extends JobSubCategoryEvent {

  final String id;

  FetchJobSubCategoryEvents({required this.id});

  @override
  // Equatable class needs to override props method
  List<AuctionModel> get props => [];
}


class JobSubCategoryBloc extends Bloc<JobSubCategoryEvent, JobSubCategoryState>{

  GetJobSubCategories jobCategories;
  Connectivity connectivity;

  JobSubCategoryBloc({required this.connectivity, required this.jobCategories}) : super(LoadingJobSubCategoryState()) {

    void fetchJobSubCategories(FetchJobSubCategoryEvents event, emit) async {

      ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

      if(connectivityResult==ConnectivityResult.none){

        emit(const ErrorJobSubCategoryState("Internet Connection Lost"));

      } else {

        final failureOrTrivia = await jobCategories(Params(catId: event.id));


        failureOrTrivia.fold((l){
          emit( const ErrorJobSubCategoryState("Server Connection Lost"));
        }, (r){
          emit(LoadedJobSubCategoryState(r));
        }
        );
      }
    }

    on<FetchJobSubCategoryEvents>(fetchJobSubCategories);

  }


}