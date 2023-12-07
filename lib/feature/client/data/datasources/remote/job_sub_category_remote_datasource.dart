import 'package:dio/dio.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/feature/client/data/model/job_sub_category_model.dart';
import 'package:workoneerweb/secrets.dart';

abstract class JobSubCategoryRemoteDataSource {

  Future<List<JobSubCategoryModel>> getAllJobSubCategory(String catId);

}

class JobSubCategoryRemoteDataSourceImpl implements JobSubCategoryRemoteDataSource {

  @override
  Future<List<JobSubCategoryModel>> getAllJobSubCategory(String catId) {
    return _getAllJobSubCategories(catId);
  }


  Future<List<JobSubCategoryModel>>  _getAllJobSubCategories(String catId) async {

    List<JobSubCategoryModel> allJobSubCategories = [];

    try{

      var dio = Dio();


      var response = await dio.get(
        "https://workoneer.com/wp-json/workoneer/v1/job_subcategories_cat_id/$catId",
        options: Options(
          headers: {
            "Authorization": basicAuth,
            "Content-Type":"application/json",
          },
        ),
      );

      for ( Map<String,dynamic> res in response.data ) {
        allJobSubCategories.add(JobSubCategoryModel.fromAPIJson(res));
      }

      return allJobSubCategories;

    }
    catch(e){
      throw ServerException(e.toString());
    }


  }



}