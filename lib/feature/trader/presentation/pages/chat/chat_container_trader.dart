import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workoneerweb/configs/app_colors.dart';
import 'package:workoneerweb/core/widgets/loading_data.dart';
import 'package:workoneerweb/core/widgets/no_data_found.dart';
import 'package:workoneerweb/feature/auth/domain/entities/message_entity.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/auth/presentation/providers/authentication_provider.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/message_bloc.dart';

class ChatContainerTrader extends StatefulWidget {

  final String chatId;
  final String traderId;

  const ChatContainerTrader({required this.chatId, required this.traderId, Key? key}) : super(key: key);

  @override
  State<ChatContainerTrader> createState() => _ChatContainerTraderState();
}

class _ChatContainerTraderState extends State<ChatContainerTrader> {
  TextEditingController messageTEC = TextEditingController();


  bool sendingMessage = false;


  Widget _buildMessageComposer() {
    return Container(
      height: 70.0,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo),
            color: AppColors.primaryColor,
            iconSize: 25.0,
            onPressed: () {},
          ),
          Expanded(
              child: TextFormField(
                controller: messageTEC,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: "Send a message ...",
                  border: InputBorder.none,
                ),
              )),
          BlocConsumer<MessagesBloc, MessagesState>(
              builder: (context, state) {

                if(state is SendMessagesLoadingState){
                  return const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.send),
                  color: AppColors.primaryColor,
                  iconSize: 25.0,
                  onPressed: () {

                    BlocProvider.of<MessagesBloc>(context)
                        .add(SendMessageToTraderEvent(jobId: widget.chatId, traderId: widget.traderId, message: messageTEC.text, userId: Provider.of<AuthenticationProvider>(context,listen: false).getUserInfo!.userId));

                    BlocProvider.of<MessagesBloc>(context)
                        .add(FetchAllMessagesEvent(jobId: widget.chatId, traderId: widget.traderId));
                  },
                );
              },
              listener: (context, state) {

              }
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(MessageEntity message, bool isMe) {
    final msg = Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: isMe
          ? const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: isMe ? Colors.red.withAlpha(90) : AppColors.primaryColor,
        borderRadius: isMe
            ? const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        )
            : const BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.text,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              )),
        ],
      ),
    );

    if (isMe) return msg;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        msg,
      ],
    );
  }

  @override
  void initState() {
    BlocProvider.of<MessagesBloc>(context)
        .add(FetchAllMessagesEvent(jobId: widget.chatId, traderId: widget.traderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height*0.08,
        title: const Center(
          child: Text(
            "CHAT",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'Marcellus',
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if(Provider.of<AuthenticationProvider>(context,listen: false).getUserInfo!.userType==UserType.client){
              GoRouter.of(context).push('/client');
            } else {
              GoRouter.of(context).push('/trader');
            }
          },
          icon: Stack(
            children: [
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              const Positioned(
                top: 5,
                left: 8,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryColor,
                  size: 15,
                ),
              ),
            ],
          ),
          splashRadius: 25.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(

            children: [

              SizedBox(
                height: MediaQuery.of(context).size.height*0.7,
                child: BlocBuilder<MessagesBloc, MessagesState>(

                  builder: (context, state) {

                    if(state is MessagesLoadingState){
                      return const LoadingData();
                    }

                    else if(state is MessagesLoadedState){

                      if(state.allMessages.isEmpty){
                        return const Center(
                          child: NoDataFound(msg: "Message"),
                        );
                      }

                      else{
                        return ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.only(top: 15.0),
                            itemCount: state.allMessages.length,
                            itemBuilder: (context, index) {
                              final MessageEntity message = state.allMessages[index];
                              final bool isMe = message.id == Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo!.userId.toString();
                              return _buildMessage(message, isMe);
                            });
                      }
                    }

                    else{
                      return const Text("WENT WRONG. CLOSE THE APP & TRY AGAIN");
                    }

                  },
                ),
              ),

              _buildMessageComposer(),

            ],
          ),
        ),
      ),
    );
  }
}
