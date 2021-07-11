import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class HiveData extends HiveObject {
  HiveData({required this.name, required this.json, required this.date});

  @HiveField(0)
  final String? name;

  @HiveField(1)
  final DateTime? date;

  @HiveField(2)
  final String? json;
}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

// generated TypeAdapter
// flutter packages pub run build_runner build

class HiveDataAdapter extends TypeAdapter<HiveData> {
  @override
  final int typeId = 0;

  @override
  HiveData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveData(
      name: fields[0] as String?,
      json: fields[2] as String?,
      date: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.json);
  }
}
