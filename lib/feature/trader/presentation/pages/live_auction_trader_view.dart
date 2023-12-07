import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/repositories/auction_repositoy_impl.dart';
import 'package:workoneerweb/feature/client/data/repositories/bidder_repository_impl.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_bidders_for_auction.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_single_auction.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/bidders_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/qna_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/qna_request_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/single_auction_bloc.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/trader_bid_remote_datasource.dart';
import 'package:workoneerweb/feature/trader/data/repositories/trader_bid_repository_impl.dart';
import 'package:workoneerweb/feature/trader/domain/use_case/post_place_bid_usecase.dart';
import 'package:workoneerweb/feature/trader/presentation/bloc/trader_add_bid_bloc.dart';
import 'package:workoneerweb/feature/trader/presentation/containers/trader_single_auction_container.dart';
import 'package:workoneerweb/injection_container.dart';
import '../../../../core/responsive/responsive_ui.dart';
import '../../../../core/responsive/use_mobile_app_dialog.dart';
import '../../../client/data/datasources/remote/auction_remote_data_source.dart';
import '../../../client/data/datasources/remote/bidder_remote_datasource.dart';
import '../common/header_view.dart';

class LiveAuctionTraderView extends StatefulWidget {

  final String jobId;

  const LiveAuctionTraderView({required this.jobId, Key? key}) : super(key: key);

  @override
  State<LiveAuctionTraderView> createState() => _LiveAuctionTraderViewState();
}

class _LiveAuctionTraderViewState extends State<LiveAuctionTraderView> {

  TextEditingController bidAmt = TextEditingController(text: '10');

  AuctionRemoteDataSourceImpl remoteDataSourceImpl = AuctionRemoteDataSourceImpl();

  AuctionRepositoryImpl? repository;

  GetSingleAuction? liveAuction;

  Connectivity? connectivity;

  BidderRemoteDataSourceImpl bidderRemoteDataSourceImpl = BidderRemoteDataSourceImpl();

  BidderRepositoryImpl? bidderRepository;

  GetAllBidderForAuction? bidderAuction;

  TraderBidRemoteDataSourceImpl bidRemoteDataSourceImpl = TraderBidRemoteDataSourceImpl();

  TraderBidRepositoryImpl? traderBidRepositoryImpl;

  PlaceBidUseCase? placeBid;

  @override
  void initState() {

    repository = AuctionRepositoryImpl(remoteDataSource: remoteDataSourceImpl);
    liveAuction = GetSingleAuction(repository!);
    connectivity = Connectivity();
    bidderRepository = BidderRepositoryImpl(remoteDataSource: bidderRemoteDataSourceImpl);
    bidderAuction = GetAllBidderForAuction(bidderRepository!);
    traderBidRepositoryImpl = TraderBidRepositoryImpl(remoteDataSource: bidRemoteDataSourceImpl);
    placeBid = PlaceBidUseCase(traderBidRepositoryImpl!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveUI.isMobile(context)? const UseAppDialog() : Scaffold(
      body: ListView(
        children: [


          const HeaderTrader(),

          MultiBlocProvider(

            providers: [

              BlocProvider<SingleAuctionBloc>(
                create: (context) => SingleAuctionBloc(widget.jobId, liveAuction!, connectivity!),
              ),

              BlocProvider<TraderPlaceBidBloc>(
                create: (context) => TraderPlaceBidBloc(placeBid: placeBid!, connectivity: connectivity!),
              ),

              BlocProvider<AuctionBidderBloc>(
                create: (context) => AuctionBidderBloc(widget.jobId, bidderAuction!, connectivity!),),

              BlocProvider<QNABloc>(
                create: (context) => sl()
              ),

              BlocProvider<QNARequestBloc>(
                  create: (context) => sl()
              ),

            ],

            child: const TraderSingleAuctionLiveContainer(),
          ),

        ],
      ),
    );
  }
}
