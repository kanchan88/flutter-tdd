import 'package:connectivity_plus/connectivity_plus.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workoneerweb/feature/client/data/datasources/remote/chat_message_remote_datasource.dart';
import 'package:workoneerweb/feature/client/data/repositories/client_chat_message_repository_impl.dart';
import 'package:workoneerweb/feature/client/domain/repositories/client_chat_message_repository.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_messages_usecase.dart';
import 'package:workoneerweb/feature/client/domain/usecase/get_all_sender_usecase.dart';
import 'package:workoneerweb/feature/client/domain/usecase/post_send_message_to_trader.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/message_bloc.dart';
import 'package:workoneerweb/feature/client/presentation/pages/chat/chat_container.dart';


class SingleChatScreen extends StatefulWidget {

  final String chatId;
  final String traderId;

  const SingleChatScreen({required this.chatId, required this.traderId, Key? key}) : super(key: key);

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {

  ChatMessageRemoteDataSourceImpl remoteDataSourceImpl = ChatMessageRemoteDataSourceImpl();

  ClientChatMessageRepository? repository;

  GetAllMessagesUseCase? liveAuction;
  GetAllSenderUseCase? senderUseCase;
  PostSendMessageToTraderUseCase? sendMessageToTraderUseCase;

  Connectivity? connectivity;

  @override
  void initState() {
    repository = ClientChatMessageRepositoryImpl(remoteDataSource: remoteDataSourceImpl);
    liveAuction = GetAllMessagesUseCase(repository: repository!);
    senderUseCase = GetAllSenderUseCase(repository: repository!);
    sendMessageToTraderUseCase = PostSendMessageToTraderUseCase(clientChatMessageRepository: repository!);
    connectivity = Connectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MessagesBloc>(create: (context) => MessagesBloc(getAllMessagesUseCase: liveAuction!, connectivity: connectivity!, getAllSenderUseCase: senderUseCase!, sendMessageToTraderUseCase: sendMessageToTraderUseCase!),),
        ],
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ChatContainer(chatId: widget.chatId, traderId: widget.traderId,),
        ),
      ),
    );
  }
}