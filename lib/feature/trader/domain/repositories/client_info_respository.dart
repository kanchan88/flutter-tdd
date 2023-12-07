import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';

abstract class ClientInfoRepository {

  Future<Either<Failure, User>> getClientInformation({ required String clientId});

}