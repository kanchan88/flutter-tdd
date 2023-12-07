//// GENERATED CODE - DO NOT MODIFY BY HAND
//
//part of 'user_hive.dart';
//
//// **************************************************************************
//// TypeAdapterGenerator
//// **************************************************************************
//
//class UserHiveAdapter extends TypeAdapter<UserHive> {
//  @override
//  final int typeId = 1;
//
//  @override
//  UserHive read(BinaryReader reader) {
//    final numOfFields = reader.readByte();
//    final fields = <int, dynamic>{
//      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//    };
//    return UserHive(
//      fullName: fields[0] as String?,
//      email: fields[2] as String?,
//      userType: fields[3] as UserType?,
//      userId: fields[1] as String?,
//    );
//  }
//
//  @override
//  void write(BinaryWriter writer, UserHive obj) {
//    writer
//      ..writeByte(4)
//      ..writeByte(0)
//      ..write(obj.fullName)
//      ..writeByte(1)
//      ..write(obj.userId)
//      ..writeByte(2)
//      ..write(obj.email)
//      ..writeByte(3)
//      ..write(obj.userType);
//  }
//
//  @override
//  int get hashCode => typeId.hashCode;
//
//  @override
//  bool operator ==(Object other) =>
//      identical(this, other) ||
//      other is UserHiveAdapter &&
//          runtimeType == other.runtimeType &&
//          typeId == other.typeId;
//}
//
//class UserTypeAdapter extends TypeAdapter<UserType> {
//  @override
//  final int typeId = 2;
//
//  @override
//  UserType read(BinaryReader reader) {
//    switch (reader.readByte()) {
//      case 0:
//        return UserType.client;
//      case 1:
//        return UserType.trader;
//      default:
//        return UserType.client;
//    }
//  }
//
//  @override
//  void write(BinaryWriter writer, UserType obj) {
//    switch (obj) {
//      case UserType.client:
//        writer.writeByte(0);
//        break;
//      case UserType.trader:
//        writer.writeByte(1);
//        break;
//    }
//  }
//
//  @override
//  int get hashCode => typeId.hashCode;
//
//  @override
//  bool operator ==(Object other) =>
//      identical(this, other) ||
//      other is UserTypeAdapter &&
//          runtimeType == other.runtimeType &&
//          typeId == other.typeId;
//}
