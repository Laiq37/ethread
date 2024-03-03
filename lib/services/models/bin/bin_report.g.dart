// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bin_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BinAdapter extends TypeAdapter<Bin> {
  @override
  final int typeId = 3;

  @override
  Bin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bin(
      id: fields[3] as int,
      startTime: fields[4] as String?,
      endTime: fields[5] as String?,
      firstPicture: fields[6] as String?,
      lastPicture: fields[7] as String?,
      audio: fields[8] as String?,
      finalComments: fields[9] as String?,
      status: fields[10] as String?,
      binFilledStatus: fields[11] as String?,
      title: fields[13] as String?,
      driverMessage: fields[14] as String?,
      isActive: fields[15] == null ? false : fields[15] as bool?,
      barcodeNum: fields[16] as String?,
      isBinScanned: fields[12] == null ? false : fields[12] as bool,
      isBinServed: fields[17] == null ? false : fields[17] as bool,
      date: fields[18] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Bin obj) {
    writer
      ..writeByte(16)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.firstPicture)
      ..writeByte(7)
      ..write(obj.lastPicture)
      ..writeByte(8)
      ..write(obj.audio)
      ..writeByte(9)
      ..write(obj.finalComments)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.binFilledStatus)
      ..writeByte(12)
      ..write(obj.isBinScanned)
      ..writeByte(13)
      ..write(obj.title)
      ..writeByte(14)
      ..write(obj.driverMessage)
      ..writeByte(15)
      ..write(obj.isActive)
      ..writeByte(16)
      ..write(obj.barcodeNum)
      ..writeByte(17)
      ..write(obj.isBinServed)
      ..writeByte(18)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BinAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
