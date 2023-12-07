import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/core/responsive/responsive_ui.dart';
import 'package:workoneerweb/core/responsive/use_mobile_app_dialog.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/auction_remote_data_source.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/bidder_remote_datasource.dart';
import 'package:workoneerweb/feature/client/data/repositories/auction_repositoy_impl.dart';
import 'package:workoneerweb/feature/client/data/repositories/bidder_repository_impl.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_bidders_for_auction.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_single_auction.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/bidders_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/qna_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/single_auction_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/common/header_view.dart';
import 'package:workoneerweb/feature/client/presentation/containers/display_single_auction_container.dart';
import 'package:workoneerweb/injection_container.dart';

class LiveAuctionDetailsView extends StatefulWidget {

  final String jobId;

  const LiveAuctionDetailsView({required this.jobId, Key? key}) : super(key: key);

  @override
  State<LiveAuctionDetailsView> createState() => _LiveAuctionDetailsViewState();
}

class _LiveAuctionDetailsViewState extends State<LiveAuctionDetailsView> {


  AuctionRemoteDataSourceImpl remoteDataSourceImpl = AuctionRemoteDataSourceImpl();

  AuctionRepositoryImpl? repository;

  GetSingleAuction? liveAuction;

  Connectivity? connectivity;

  BidderRemoteDataSourceImpl bidderRemoteDataSourceImpl = BidderRemoteDataSourceImpl();

  BidderRepositoryImpl? bidderRepository;

  GetAllBidderForAuction? bidderAuction;

  @override
  void initState() {

    repository = AuctionRepositoryImpl(remoteDataSource: remoteDataSourceImpl);
    liveAuction = GetSingleAuction(repository!);
    connectivity = Connectivity();
    bidderRepository = BidderRepositoryImpl(remoteDataSource: bidderRemoteDataSourceImpl);
    bidderAuction = GetAllBidderForAuction(bidderRepository!);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveUI.isMobile(context)? const UseAppDialog() : Scaffold(
      body: ListView(
        children: [

          const Header(),

          MultiBlocProvider(

            providers: [

              BlocProvider<SingleAuctionBloc>(
                create: (context) => SingleAuctionBloc(widget.jobId, liveAuction!, connectivity!),
              ),

              BlocProvider<AuctionBidderBloc>(
                create: (context) => AuctionBidderBloc(widget.jobId, bidderAuction!, connectivity!),),

              BlocProvider<QNABloc>(
                create: (context) => sl(),
              ),

            ],

            child: const DisplaySingleLiveAuctionContainer(),

          ),

        ],
      ),
    );
  }
}