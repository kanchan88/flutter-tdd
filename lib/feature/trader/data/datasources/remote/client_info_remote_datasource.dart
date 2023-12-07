import 'package:dio/dio.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/feature/auth/data/model/user_model.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/secrets.dart';

abstract class ClientInfoRemoteDataSource {

  Future<User> getClientInfo(String clientId);

}

class ClientInfoRemoteDataSourceImpl extends ClientInfoRemoteDataSource {


  @override
  Future<User> getClientInfo(String clientId) {
    return _getInfoClient(clientId);
  }


  Future<User> _getInfoClient(String userID) async {


    User currentBidder = User(
        userId: "",
        email: "",
        fullName: "",
        phone: "",
        status: "",
        postCode: "",
      userType: UserType.client,
      streetAddress: "",
      country: "",
      profilePhoto: ""
    );

    try{

      var dio = Dio(
      );
      var response = await dio.get(
        "https://workoneer.com/wp-json/workoneer/v1/get_user/$userID",
        options: Options(
          headers: {
            "Authorization": basicAuth,
            "Content-Type": "application/json",
          },
        ),
      );

      currentBidder = UserModel.fromAPIJson(response.data['data']);

      return currentBidder;

    }
    catch(e){
      throw ServerException(e.toString());
    }
  }


}