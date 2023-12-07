import 'package:workoneerweb/feature/client/domain/entities/job_sub_category_entity.dart';

class JobSubCategoryModel extends JobSubCategoryEntity {

  JobSubCategoryModel({required String id, required String name})
      : super(id: id, name: name);

  factory JobSubCategoryModel.fromAPIJson(Map<String, dynamic> json) {
    return JobSubCategoryModel(
        id: json['wot_subcat_id'],
        name: json['wot_subcat_name'],
    );
  }

}
