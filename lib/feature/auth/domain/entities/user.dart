
import 'package:equatable/equatable.dart';


enum UserType { trader, client }

class User extends Equatable{

  String userId;
  String email;
  String fullName;
  String phone;
  String status;
  String profilePhoto;
  String postCode;
  String streetAddress;
  String country;
  UserType userType;

  User({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.status,
    required this.profilePhoto,
    required this.postCode,
    required this.streetAddress,
    required this.country,
    required this.userType,
  });

  void setUser(UserType userType){
    this.userType = userType;
  }

  @override
  List<Object> get props => [userId, email, fullName, phone, status, profilePhoto, postCode, streetAddress, country, userType];

}