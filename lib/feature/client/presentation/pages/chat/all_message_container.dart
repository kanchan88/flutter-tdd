import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workoneerweb/configs/app_colors.dart';
import 'package:workoneerweb/core/widgets/loading_data.dart';
import 'package:workoneerweb/core/widgets/no_data_found.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/auth/presentation/providers/authentication_provider.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/message_bloc.dart';

class AllMessagesScreen extends StatefulWidget {

  final String chatId;

  const AllMessagesScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<AllMessagesScreen> createState() => _AllMessagesScreenState();
}

class _AllMessagesScreenState extends State<AllMessagesScreen> {

  final snackBar = const  SnackBar(
    content: Text('Messages refreshed!'),
    duration: Duration(seconds: 1),
    backgroundColor: AppColors.primaryColor,
  );


  @override
  void initState() {
    BlocProvider.of<MessagesBloc>(context).add(FetchAllSendersEvent(
        jobId: widget.chatId,
    ));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height*0.08,
          title: const Center(
            child: Text(
              "ALL MESSAGES",
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height*0.7,
                  child: BlocBuilder<MessagesBloc, MessagesState>(

                    builder: (context, state) {

                      if(state is MessagesLoadingState){
                        return const LoadingData();
                      }

                      else if(state is SendersLoadedState){
                        if(state.allSenders.isEmpty){
                          return const NoDataFound(msg: "MESSAGE");
                        }

                        else{
                          return SizedBox(
                            height: MediaQuery.of(context).size.height*0.75,
                            child: ListView.builder(
                              itemCount: state.allSenders.length,
                              itemBuilder: (context, index){
                                return InkWell(

                                  onTap: (){

                                    GoRouter.of(context).goNamed(
                                      'single-chat',
                                      params: {
                                        'job':widget.chatId,
                                        'trader':state.allSenders[index].userId.toString()
                                      },
                                    );

                                  },

                                  child: Card(
                                    margin: const EdgeInsets.all(10),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child:InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          title:Text(
                                            state.allSenders[index].fullName.toString(),
                                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                              fontFamily: 'MontserratBold',
                                            ),
                                          ),
                                          subtitle: const Text(
                                            "has messaged you!",
                                          ),
                                          leading: const CircleAvatar(),
                                        ),
                                      ),
                                    ),
                                  ),

                                );
                              },
                            ),
                          );
                        }
                      }

                      else{
                        return const LoadingData();
                      }

                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}