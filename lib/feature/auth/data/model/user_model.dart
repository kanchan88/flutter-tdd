
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';

class UserModel extends User{

  UserModel({
    required String userId,
    required String email,
    required String fullName,
    required String phone,
    required String status,
    required String profilePhoto,
    required String postCode,
    required String streetAddress,
    required String country,
    required UserType userType,
  }) :super (userId: userId, email: email, fullName: fullName, postCode: postCode, phone: phone,
      profilePhoto: profilePhoto, status: status, streetAddress: streetAddress, country: country, userType: userType);

  factory UserModel.fromJson(Map<String,dynamic> val){

    return UserModel(
      userId: val['id'].toString(),
      email: val['userEmail'].toString(),
      fullName: val['fullName'].toString(),
      phone: val['phoneNumber'].toString(),
      status: val['status'].toString(),
      profilePhoto: val['profilePhoto'].toString(),
      streetAddress: val['street_address'],
      postCode: val['postalCode'],
      country: val['country'],
      userType: UserType.trader
    );

  }

  factory UserModel.fromAPIJson(Map<String,dynamic> val){

    return UserModel(
        userId: val['ID'].toString(),
        email: val['user_login'].toString(),
        fullName: val['first_name'].toString(),
        phone: val['phone'].toString(),
        status: 'true',
        profilePhoto: val['profile_image'].toString(),
        postCode: val['postal_code'],
        country: 'null',
        streetAddress: val['postal_address'],
        userType: UserType.trader
    );

  }

}