import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoneerweb/core/provider/login_state_provider.dart';
import '/feature/auth/presentation/providers/authentication_provider.dart';
import '/feature/client/data/datasources/remote/auction_remote_data_source.dart';
import '/feature/client/data/datasources/remote/chat_message_remote_datasource.dart';
import '/feature/client/data/datasources/remote/client_auth_remote_data_source.dart';
import '/feature/client/data/datasources/remote/question_answer_remote_data_source.dart';
import '/feature/client/data/repositories/auction_repositoy_impl.dart';
import '/feature/client/data/repositories/client_auth_repo_impl.dart';
import '/feature/client/data/repositories/client_chat_message_repository_impl.dart';
import '/feature/client/data/repositories/qna_repository_impl.dart';
import '/feature/client/domain/repositories/auction_repository.dart';
import '/feature/client/domain/repositories/client_auth_repo.dart';
import '/feature/client/domain/repositories/client_chat_message_repository.dart';
import '/feature/client/domain/repositories/qna_repository.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_messages_usecase.dart';
import '/feature/client/domain/usecase/get_all_qna_usecase.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_sender_usecase.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_single_auction.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_answer_qna_usecase.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_auction_usecase.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_client_register_usecase.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_client_reset_pass_usecase.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_client_update_use_case.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_login_client_usecase.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_question_qna_usecase.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_send_message_to_trader.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/add_auction_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/client_auth_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/client_update_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/message_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/qna_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/qna_request_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/single_auction_bloc.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/auction_remote_data_source.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/client_info_remote_datasource.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/trader_auth_remote_data_source.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/trader_bid_remote_datasource.dart';
import 'package:workoneerweb/feature/trader/data/repositories/client_info_repository_impl.dart';
import 'package:workoneerweb/feature/trader/data/repositories/trader_auction_repository_impl.dart';
import 'package:workoneerweb/feature/trader/data/repositories/trader_auth_repo_impl.dart';
import '/feature/trader/data/repositories/trader_bid_repository_impl.dart';
import '/feature/trader/domain/repositories/auction_repository.dart';
import '/feature/trader/domain/repositories/client_info_respository.dart';
import '/feature/trader/domain/repositories/trader_bid_repository.dart';
import '/feature/trader/domain/use_case/get_client_details_use_case.dart';
import '/feature/trader/domain/use_case/get_traders_live_auctions.dart';
import '/feature/trader/domain/use_case/get_traders_won_auctions.dart';
import '/feature/trader/domain/use_case/post_place_bid_usecase.dart';
import '/feature/trader/domain/use_case/post_reset_trader_pass_usecase.dart';
import '/feature/trader/domain/use_case/post_trader_login_usecase.dart';
import '/feature/trader/domain/use_case/post_trader_register_usecase.dart';
import '/feature/trader/domain/use_case/post_update_trader_usecase.dart';
import '/feature/trader/presentation/bloc/client_details_bloc.dart';
import '/feature/trader/presentation/bloc/trader_add_bid_bloc.dart';
import '/feature/trader/presentation/bloc/trader_auction_bloc.dart';
import '/feature/trader/presentation/bloc/trader_auth_bloc.dart';
import '/feature/trader/presentation/bloc/trader_update_bloc.dart';
import 'feature/trader/domain/repositories/trader_auth_repo.dart';

final sl = GetIt.instance;

Future<void> startSingleAuction() async {

  sl.registerFactory(() => SingleAuctionBloc(sl(), sl(), sl()));


  sl.registerLazySingleton<GetSingleAuction>(
          () => GetSingleAuction(sl())
  );

  sl.registerLazySingleton<AuctionRepository>(() => AuctionRepositoryImpl(remoteDataSource: sl()) );

  sl.registerLazySingleton<AuctionRemoteDataSource>(() => AuctionRemoteDataSourceImpl());

}

Future<void> initializeDependencies () async {

  // bloc
  sl.registerFactory(() => TraderJobsBloc(sl(), sl()));
  sl.registerFactory(() => TraderPlaceBidBloc(placeBid: sl(), connectivity: sl()));
  sl.registerFactory(() => ClientDetailBloc(sl(), sl()));
  sl.registerFactory(() => AddAuctionBloc(sl(), sl()));
  sl.registerFactory(() => QNABloc(sl(), sl(),));
  sl.registerFactory(() => QNARequestBloc(sl(), sl(), sl()));
  sl.registerFactory(() => ClientAuthBloc(sl(), sl(), sl()));
  sl.registerFactory(() => TraderAuthBloc(sl(), sl(), sl()));
  sl.registerFactory(() => TraderAccountUpdateBloc(traderUpdateUseCase: sl(), resetPassUseCase: sl(), connectivity: sl()));
  sl.registerFactory(() => ClientAccountUpdateBloc(clientUpdateUseCase: sl(), connectivity: sl(), passUseCase: sl()));
  sl.registerFactory(() => MessagesBloc(connectivity: sl(), getAllMessagesUseCase: sl(), getAllSenderUseCase: sl(), sendMessageToTraderUseCase: sl()));

  // use-case
  sl.registerLazySingleton<GetTraderLiveAuction>(
          () => GetTraderLiveAuction(repository: sl())
  );

  sl.registerLazySingleton<PlaceBidUseCase>(
          () => PlaceBidUseCase(sl())
  );

  sl.registerLazySingleton<PostAuctionUseCase>(
          () => PostAuctionUseCase(auctionRepository: sl())
  );

  sl.registerLazySingleton<GetClientDetailsUseCase>(
          () => GetClientDetailsUseCase(repository: sl())
  );

  sl.registerLazySingleton<GetTraderWonAuction>(
          () => GetTraderWonAuction(repository: sl())
  );

  sl.registerLazySingleton<GetAllQNAUseCase>(
          () => GetAllQNAUseCase(qnaRepository: sl())
  );

  sl.registerLazySingleton<PostQuestionQNAUseCase>(
          () => PostQuestionQNAUseCase(qnaRepository: sl())
  );

  sl.registerLazySingleton<PostAnswerQNAUseCase>(
          () => PostAnswerQNAUseCase(qnaRepository: sl())
  );

  sl.registerLazySingleton<PostClientLoginUseCase>(
          () => PostClientLoginUseCase(clientAuthRepository: sl())
  );

  sl.registerLazySingleton<PostClientRegisterUseCase>(
          () => PostClientRegisterUseCase(clientAuthRepository: sl())
  );

  sl.registerLazySingleton<PostTraderLoginUseCase>(
          () => PostTraderLoginUseCase(traderAuthRepository: sl())
  );

  sl.registerLazySingleton<PostTraderRegisterUseCase>(
          () => PostTraderRegisterUseCase(traderAuthRepository: sl())
  );

  sl.registerLazySingleton<PostTraderUpdateUseCase>(
          () => PostTraderUpdateUseCase(traderAuthRepository: sl())
  );

  sl.registerLazySingleton<PostClientUpdateUseCase>(
          () => PostClientUpdateUseCase(clientAuthRepository: sl())
  );

  sl.registerLazySingleton<PostTraderResetPassUseCase>(
          () => PostTraderResetPassUseCase(traderAuthRepository: sl())
  );

  sl.registerLazySingleton<PostClientResetPassUseCase>(
          () => PostClientResetPassUseCase(clientAuthRepository: sl())
  );

  sl.registerLazySingleton<GetAllMessagesUseCase>(
          () => GetAllMessagesUseCase(repository: sl())
  );

  sl.registerLazySingleton<GetAllSenderUseCase>(
          () => GetAllSenderUseCase(repository: sl())
  );

  sl.registerLazySingleton<PostSendMessageToTraderUseCase>(
          () => PostSendMessageToTraderUseCase(clientChatMessageRepository: sl())
  );

  // data-source
  sl.registerLazySingleton<TraderAuctionRemoteDataSource>(() => TraderAuctionRemoteDataSourceImpl());
  sl.registerLazySingleton<TraderBidRemoteDataSource>(() => TraderBidRemoteDataSourceImpl());
  sl.registerLazySingleton<ClientInfoRemoteDataSource>(() => ClientInfoRemoteDataSourceImpl());
  sl.registerLazySingleton<AuctionRemoteDataSource>(() => AuctionRemoteDataSourceImpl());
  sl.registerLazySingleton<QNARemoteDataSource>(() => QNARemoteDataSourceImpl());
  sl.registerLazySingleton<ClientAuthRemoteDataSource>(() => ClientAuthRemoteDataSourceImpl());
  sl.registerLazySingleton<TraderAuthRemoteDataSource>(() => TraderAuthRemoteDataSourceImpl());
  sl.registerLazySingleton<ChatMessagesRemoteDataSource>(() => ChatMessageRemoteDataSourceImpl());

  // repo
  sl.registerLazySingleton<TraderAuctionRepository>(() => TraderAuctionRepositoryImpl(traderAuctionRemoteDataSource: sl()) );
  sl.registerLazySingleton<TraderBidRepository>(() => TraderBidRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ClientInfoRepository>(() => ClientInfoRepositoryImpl(clientInfoRemoteDataSource: sl()));
  sl.registerLazySingleton<AuctionRepository>(() => AuctionRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<QNARepository>(() => QNARepositoryImpl(qnaRemoteDataSource: sl()));
  sl.registerLazySingleton<ClientAuthRepository>(() => ClientAuthRepositoryImpl(authRemoteDataSource: sl()));
  sl.registerLazySingleton<TraderAuthRepository>(() => TraderAuthRepositoryImpl(authRemoteDataSource: sl()));
  sl.registerLazySingleton<ClientChatMessageRepository>(() => ClientChatMessageRepositoryImpl(remoteDataSource: sl()));

  // Other
  sl.registerSingleton<String>('');
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<AuthenticationProvider>(() => AuthenticationProvider());

}