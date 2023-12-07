import 'package:workoneerweb/feature/client/domain/entities/job_category_entity.dart';

class JobCategoryModel extends JobCategoryEntity {

  JobCategoryModel({required String id, required String name})
      : super(id: id, name: name);

  factory JobCategoryModel.fromAPIJson(Map<String, dynamic> json) {
    return JobCategoryModel(id: json['wot_go_cat_id'], name: json['wot_cat_name']);
  }

}
