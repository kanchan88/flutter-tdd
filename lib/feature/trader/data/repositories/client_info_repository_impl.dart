
import 'package:dartz/dartz.dart';
import 'package:workoneerweb/core/error/expection.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/trader/data/datasources/remote/client_info_remote_datasource.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/client_info_respository.dart';

class ClientInfoRepositoryImpl extends ClientInfoRepository {

  ClientInfoRemoteDataSource clientInfoRemoteDataSource;

  ClientInfoRepositoryImpl({required this.clientInfoRemoteDataSource});

  @override
  Future<Either<Failure, User>> getClientInformation({required String clientId}) {
    return returnFailureOrClientInfo(clientId);
  }

  Future<Either<Failure, User>> returnFailureOrClientInfo(String clientId) async {

    try {
      User client = await clientInfoRemoteDataSource.getClientInfo(clientId);
      return Right(client);
    } on ServerException {
      return const Left(FetchServerDataFailure(textMsg: 'Server Failure'));
    }

  }


}