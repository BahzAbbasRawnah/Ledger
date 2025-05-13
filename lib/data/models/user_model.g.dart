// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      phoneNumber: fields[1] as String,
      businessName: fields[2] as String?,
      businessPhone: fields[3] as String?,
      businessLogo: fields[4] as String?,
      registrationDate: fields[5] as DateTime,
      trialEndDate: fields[6] as DateTime,
      isPremium: fields[7] as bool,
      preferredCurrency: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.businessName)
      ..writeByte(3)
      ..write(obj.businessPhone)
      ..writeByte(4)
      ..write(obj.businessLogo)
      ..writeByte(5)
      ..write(obj.registrationDate)
      ..writeByte(6)
      ..write(obj.trialEndDate)
      ..writeByte(7)
      ..write(obj.isPremium)
      ..writeByte(8)
      ..write(obj.preferredCurrency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
