import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:workoneerweb/core/error/failures.dart';
import 'package:workoneerweb/core/usecase/usecase.dart';
import 'package:workoneerweb/feature/auth/domain/entities/user.dart';
import 'package:workoneerweb/feature/trader/domain/repositories/client_info_respository.dart';

class GetClientDetailsUseCase implements UseCase<User, Params> {

  final ClientInfoRepository repository;

  GetClientDetailsUseCase({ required this.repository});

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return repository.getClientInformation(clientId: params.userId);
  }
}

class Params extends Equatable {
  final String userId;

  const Params({required this.userId});

  @override
  List<Object> get props => [userId];
}
