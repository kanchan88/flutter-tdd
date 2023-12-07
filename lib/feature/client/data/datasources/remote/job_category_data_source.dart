import 'package:dio/dio.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/feature/client/data/model/job_category_model.dart';
import 'package:workoneerweb/secrets.dart';

abstract class JobCategoryRemoteDataSource {

  Future<List<JobCategoryModel>> getAllJobCategory();

}

class JobCategoryRemoteDataSourceImpl implements JobCategoryRemoteDataSource {

  @override
  Future<List<JobCategoryModel>> getAllJobCategory() {
    return _getAllJobCategories();
  }


  Future<List<JobCategoryModel>>  _getAllJobCategories() async {

    List<JobCategoryModel> allJobCategories = [];

    try{

      var dio = Dio();
      var response = await dio.get(
        "https://workoneer.com/wp-json/workoneer/v1/job_categories",
        options: Options(
          headers: {
            "Authorization": basicAuth,
            "Content-Type":"application/json",
          },
        ),
      );

      for ( Map<String,dynamic> res in response.data ) {
        allJobCategories.add(JobCategoryModel.fromAPIJson(res));
      }

      return allJobCategories;

    }
    catch(e){
      throw ServerException(e.toString());
    }


  }



}