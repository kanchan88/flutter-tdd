import 'package:connectivity_plus/connectivity_plus.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/pages/chat/chat_container.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/chat_with_admin_remote_data_source.dart';
import 'package:workoneerweb/feature/trader/data/repositories/chat_with_admin_repository_impl.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/chat_with_admin_repository.dart';
import 'package:workoneerweb/feature/trader/domain/use_case/get_all_messages_with_admin_usecase.dart';
import 'package:workoneerweb/feature/trader/domain/use_case/post_send_message_to_admin_usecase.dart';
import 'package:workoneerweb/feature/trader/presentation/bloc/chat_with_admin_bloc.dart';
import 'package:workoneerweb/feature/trader/presentation/pages/chat_admin/chat_container_trader.dart';


class SingleChatScreenTraderAdmin extends StatefulWidget {

  final String chatId;
  final String traderId;

  const SingleChatScreenTraderAdmin({required this.chatId, required this.traderId, Key? key}) : super(key: key);

  @override
  State<SingleChatScreenTraderAdmin> createState() => _SingleChatScreenTraderAdminState();
}

class _SingleChatScreenTraderAdminState extends State<SingleChatScreenTraderAdmin> {

  ChatWithAdminRemoteDataSourceImpl remoteDataSourceImpl = ChatWithAdminRemoteDataSourceImpl();

  ChatWithAdminRepository? repository;

  GetAllMessagesWithAdminUseCase? allMessagesWithAdminUseCase;
  PostSendMessageToAdminUseCase? sendMessageToAdminUseCase;

  Connectivity? connectivity;

  @override
  void initState() {
    repository = ChatWithAdminRepositoryImpl(remoteDataSource: remoteDataSourceImpl);
    allMessagesWithAdminUseCase = GetAllMessagesWithAdminUseCase(repository: repository!);
    allMessagesWithAdminUseCase = GetAllMessagesWithAdminUseCase(repository: repository!);
    sendMessageToAdminUseCase = PostSendMessageToAdminUseCase(chatWithAdminRepository: repository!);
    connectivity = Connectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AdminMessagesBloc>(create: (context) => AdminMessagesBloc(getAllMessagesUseCase: allMessagesWithAdminUseCase!, connectivity:connectivity!, sendMessageToAdminUseCase: sendMessageToAdminUseCase! ),),
        ],
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ChatContainerTraderAdmin(chatId: widget.chatId, traderId: widget.traderId,),
        ),
      ),
    );
  }
}