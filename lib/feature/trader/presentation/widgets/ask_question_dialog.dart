import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workoneerweb/configs/app_colors.dart';
import 'package:workoneerweb/feature/client/presentation/bloc/qna_request_bloc.dart';


class AskQuestionDialog extends StatefulWidget {

  final String jobId;

  const AskQuestionDialog({Key? key, required this.jobId}):super(key: key);

  @override
  State<AskQuestionDialog> createState() => _AskQuestionDialogState();
}

class _AskQuestionDialogState extends State<AskQuestionDialog> {

  TextEditingController questionTEC = TextEditingController();

  final FocusNode questionFN = FocusNode();

  final _addNewKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.height*0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _addNewKey,
            child:  ListView(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(""),

                    Text("Add Question", style: Theme.of(context).textTheme.headline4,),

                    IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.close))
                  ],
                ),

                const SizedBox(height: 20.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: questionFN,
                        textInputAction: TextInputAction.done,
                        cursorColor: AppColors.primaryColor,
                        controller: questionTEC,
                        keyboardType: TextInputType.text,
                        validator: (val){
                          if(val!.isEmpty){
                            return "Question field can not be empty!";
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 16.0),
                        decoration: InputDecoration(
                            fillColor: const Color(0xFfF6F6F6),
                            filled: true,
                            hintText: "Ask Question",
                            hintStyle: const TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color:Colors.grey, width: 1.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20)),
                      ),
                    ),

                    const SizedBox(width: 10.0,),

                  ],
                ),

                const SizedBox(height: 20.0,),


                BlocConsumer<QNARequestBloc, QNARequestState>(
                    listener: (context, state) {
                      if(state is QNARequestLoadedState){
                        Fluttertoast.showToast(msg: 'Question Send');
                        Navigator.pop(context);
                      } else if(state is QNARequestFailedState){
                        Fluttertoast.showToast(msg: 'Failed to Ask Question');
                        Navigator.pop(context);
                      }
                    },

                    builder: (context, state){
                      if(state is QNARequestLoadingState){
                        return Column(
                          children: const [
                            CircularProgressIndicator(),
                            Text('Asking Question')
                          ],
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                            ),
                            child: const Text("Cancel", style: TextStyle(fontSize: 18),),
                          ),

                          const SizedBox(width: 10.0,),

                          ElevatedButton(
                            onPressed: () async {
                              if(_addNewKey.currentState!.validate()) {
                                BlocProvider.of<QNARequestBloc>(context).add(RaiseQuestionEvents(jobId: widget.jobId, questionText: questionTEC.text));
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
                            ),
                            child: const Text("Add Question", style: TextStyle(fontSize: 18),),
                          )
                        ],
                      );
                    }

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}