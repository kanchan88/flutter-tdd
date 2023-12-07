import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workoneerweb/core/provider/login_state_provider.dart';
import 'package:workoneerweb/core/responsive/responsive_ui.dart';
import 'package:workoneerweb/core/responsive/use_mobile_app_dialog.dart';
import 'package:workoneerweb/feature/auth/presentation/providers/authentication_provider.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/job_category_data_source.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/job_sub_category_remote_datasource.dart';
import 'package:workoneerweb/feature/client/data/repositories/job_category_repository_impl.dart';
import 'package:workoneerweb/feature/client/data/repositories/job_sub_category_repository_impl.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_job_subcategory.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/add_auction_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/job_category_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/job_sub_category_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/common/header_view.dart';
import 'package:workoneerweb/feature/client/presentation/containers/add_job_carousel_container.dart';
import 'package:workoneerweb/feature/client/presentation/widgets/sidebar_dashboard.dart';
import 'package:workoneerweb/injection_container.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../trader/presentation/common/un_autenticated_view.dart';
import '../../domain/usecase/get_job_categories.dart';

class ShowAddAuctionScreen extends StatefulWidget {
  const ShowAddAuctionScreen({Key? key}) : super(key: key);

  @override
  State<ShowAddAuctionScreen> createState() => _ShowAddAuctionScreenState();
}

class _ShowAddAuctionScreenState extends State<ShowAddAuctionScreen> {

  JobCategoryRemoteDataSourceImpl remoteDataSourceImpl = JobCategoryRemoteDataSourceImpl();

  JobSubCategoryRemoteDataSourceImpl subCatRemoteDataSourceImpl = JobSubCategoryRemoteDataSourceImpl();

  JobCategoryRepositoryImpl? repository;

  JobSubCategoryRepositoryImpl? jobSubCategoryRepositoryImpl;

  GetJobCategories? getJobs;

  GetJobSubCategories? getSubJobs;

  Connectivity? connectivity;



  @override
  void initState() {
    repository = JobCategoryRepositoryImpl(remoteDataSource: remoteDataSourceImpl);
    getJobs = GetJobCategories(jobCategoryRepository: repository!);

    jobSubCategoryRepositoryImpl = JobSubCategoryRepositoryImpl(remoteDataSource: subCatRemoteDataSourceImpl);
    getSubJobs = GetJobSubCategories(jobSubCategoryRepository: jobSubCategoryRepositoryImpl!);

    connectivity = Connectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ResponsiveUI.isMobile(context)? const UseAppDialog() : ListView(
          children: [
            const Header(),
            Provider.of<LoginStateProvider>(context, listen:false).userType!=UserType.client ? const UnAuthenticatedView(user: 'client'):
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.07,
                  vertical: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Sidebar(),
                  ),

                  const SizedBox(
                    width: 20.0,
                  ),

                  MultiBlocProvider(

                    providers: [

                      BlocProvider<JobCategoryBloc>(
                        create: (context) => JobCategoryBloc(connectivity: connectivity!, jobCategories: getJobs!),
                      ),

                      BlocProvider<JobSubCategoryBloc>(
                        create: (context) => JobSubCategoryBloc(connectivity: connectivity!, jobCategories: getSubJobs!),
                      ),

                      BlocProvider<AddAuctionBloc>(
                        create: (context) => sl(),
                      ),

                    ],

                    child: const AddJobCarouselContainer(),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

}