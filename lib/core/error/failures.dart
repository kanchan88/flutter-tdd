import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {

  final String text;

  const Failure({required this.text});

  @override
  List<Object> get props => [];
}

// General failures

class InvalidDataFailure extends Failure {

  final String textMsg;

  const InvalidDataFailure({required this.textMsg}):super(text: textMsg);
}

class FetchServerDataFailure extends Failure {

  final String textMsg;

  const FetchServerDataFailure({required this.textMsg}):super(text: textMsg);

}

class NoInternetConnectionFailure extends Failure {

  final String textMsg;

  const NoInternetConnectionFailure({required this.textMsg}):super(text: textMsg);

}