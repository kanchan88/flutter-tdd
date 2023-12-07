import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workoneerweb/feature/client/domain/entities/qna_entity.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/qna_request_bloc.dart';
import '/configs/app_colors.dart';

class AnswerAuctionQuestions extends StatefulWidget {

  final QNAEntity qna;
  final String jobId;

  const AnswerAuctionQuestions({Key? key,required this.jobId, required this.qna}) : super(key: key);

  @override
  State<AnswerAuctionQuestions> createState() => _AnswerAuctionQuestionsState();
}

class _AnswerAuctionQuestionsState extends State<AnswerAuctionQuestions> {

  bool isText = true;

  TextEditingController answerTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight*1.5,
          title: const Center(
            child: Text(
              "Answer Question",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'Marcellus',
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: const Color(0xFFFAFAFA),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.07,
            vertical: MediaQuery.of(context).size.height * 0.05,
          ),
          child: BlocConsumer<QNARequestBloc, QNARequestState>(
            listener: (context, state) {
              if(state is QNARequestLoadedState){
                Fluttertoast.showToast(msg: 'ANSWER REPLIED');
                Navigator.pop(context);
              }
              else if(state is QNARequestFailedState){

              }
            },
            builder: (context, state){
              if(state is QNARequestLoadingState){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                      Text('Replying to answer. Please wait')
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // questions
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Questions from Tradesman',
                              style: TextStyle(fontSize: 22, fontFamily: "Marcellus"),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color:AppColors.primaryColor.withOpacity(0.3))
                              ),
                              child: Text(
                                  widget.qna.question['text']
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      // answer
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Answer',
                              style: TextStyle(fontSize: 18, fontFamily: "Marcellus"),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

                            Container(
                              padding: const EdgeInsets.all(10.0),
                              color: AppColors.bgGreyColor,
                              child: TextFormField(
                                maxLines: 8,
                                textInputAction: TextInputAction.done,
                                controller: answerTEC,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "Answer here",
                                ),
                              ),

                            ),

                            const SizedBox(height: 10.0,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.2,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      if(answerTEC.text.isNotEmpty) {
                                        BlocProvider.of<QNARequestBloc>(context).add(ReplyAnswerEvents(jobId: widget.jobId, questionText: answerTEC.text, qnId: widget.qna.qnaId));
                                      }
                                    },
                                    child: const Padding(
                                      padding:EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                      child: Center(child: Text('Submit', style: TextStyle( fontSize: 18, fontFamily: "Marcellus"),)),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ),
    );
  }
}
