import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/repositories/auction_repositoy_impl.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_single_auction.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/single_auction_bloc.dart';
import 'package:workoneerweb/feature/trader/presentation/containers/trader_won_auction_container.dart';
import '../../../../core/responsive/responsive_ui.dart';
import '../../../../core/responsive/use_mobile_app_dialog.dart';
import '../../../client/data/datasources/remote/auction_remote_data_source.dart';
import '../common/header_view.dart';

class WonAuctionTraderView extends StatefulWidget {

  final String jobId;

  const WonAuctionTraderView({required this.jobId, Key? key}) : super(key: key);

  @override
  State<WonAuctionTraderView> createState() => _WonAuctionTraderViewState();
}

class _WonAuctionTraderViewState extends State<WonAuctionTraderView> {

  TextEditingController bidAmt = TextEditingController(text: '10');

  AuctionRemoteDataSourceImpl remoteDataSourceImpl = AuctionRemoteDataSourceImpl();

  AuctionRepositoryImpl? repository;

  GetSingleAuction? liveAuction;

  Connectivity? connectivity;



  @override
  void initState() {

    repository = AuctionRepositoryImpl(remoteDataSource: remoteDataSourceImpl);
    liveAuction = GetSingleAuction(repository!);
    connectivity = Connectivity();

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


            ],

            child: const TraderWonAuctionContainer(),
          ),

        ],
      ),
    );
  }
}
