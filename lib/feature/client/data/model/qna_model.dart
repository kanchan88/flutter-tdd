import 'package:workoneerweb/feature/client/domain/entities/qna_entity.dart';

class QNAModel extends QNAEntity {
  QNAModel({required super.qnaId, required super.answer, required super.question});

  factory QNAModel.fromJson(Map<dynamic, dynamic> val) {
    return QNAModel(
        qnaId: val['id'], answer: val['answer'], question: val['question']);
  }
}
