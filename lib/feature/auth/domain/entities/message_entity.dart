

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {

  final String id;
  final String text;
  final Timestamp timestamp;
  final bool isSeen;

  const MessageEntity({required this.id, required this.text, required this.timestamp, required this.isSeen});

  @override
  List<Object?> get props => [id];

}