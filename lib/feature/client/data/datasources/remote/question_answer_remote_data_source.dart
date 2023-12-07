import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/feature/client/data/model/qna_model.dart';

abstract class QNARemoteDataSource {

  Future<List<QNAModel>> getAllQuestionWithAnswer(String auctionId);
  Future<bool> postQuestion(String jobId, String text);
  Future<bool> postAnswer(String jobId, String qnId, String text);


}

class QNARemoteDataSourceImpl implements QNARemoteDataSource {

  final qnaRef = FirebaseFirestore.instance.collection("qna");

  @override
  Future<List<QNAModel>> getAllQuestionWithAnswer(String auctionId) {
    return getAllQuestionAnswer(auctionId);
  }

  @override
  Future<bool> postAnswer(String jobId, String qnId, String text) {
    return replyAnswer(jobId, qnId, text);
  }

  @override
  Future<bool> postQuestion(String jobId, String text) {
    return askQuestion(jobId, text);
  }


  Future<List<QNAModel>> getAllQuestionAnswer (String jobId) async {

    List<QNAModel> allQuestionAnswer = [];

    try {

      var qnas = await qnaRef.doc(jobId).collection('question_with_answer').get();

      for(var qna in qnas.docs){
        QNAModel questionAnswerModel = QNAModel.fromJson(qna.data());
        allQuestionAnswer.add(questionAnswerModel);
      }

      return allQuestionAnswer;

    }

    catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<bool> replyAnswer (String jobId, String qnId, String text) async {

    try {

      var qnas = qnaRef.doc(jobId).collection('question_with_answer');

      await qnas.doc(qnId).set({
        'answer':{
          'text': text,
          'status':false,
        }
      }, SetOptions(merge: true));

      return true;

    }

    catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<bool> askQuestion (String jobId, String text) async {

    try {

      String uniqueId = const Uuid().v4();

      var qnas = qnaRef.doc(jobId).collection('question_with_answer');

      await qnas.doc(uniqueId).set({
        'id':uniqueId,
        'question':{
          'text': text,
          'status':false,
        },
        'answer':{
          'text': '',
          'status':false,
        }
      });

      return true;

    }

    catch (e) {
      throw ServerException(e.toString());
    }
  }

}