// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaFileAdapter extends TypeAdapter<MediaFile> {
  @override
  final int typeId = 1;

  @override
  MediaFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaFile(
      id: fields[0] as String?,
      type: fields[1] as String?,
      attribute: fields[2] as String?,
      sizeMB: fields[3] as double?,
      extension: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MediaFile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.attribute)
      ..writeByte(3)
      ..write(obj.sizeMB)
      ..writeByte(4)
      ..write(obj.extension);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaFile _$MediaFileFromJson(Map<String, dynamic> json) => MediaFile(
      id: json['id'] as String?,
      type: json['type'] as String?,
      attribute: json['attribute'] as String?,
      sizeMB: (json['sizeMB'] as num?)?.toDouble(),
      extension: json['extension'] as String?,
    );

Map<String, dynamic> _$MediaFileToJson(MediaFile instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attribute': instance.attribute,
      'sizeMB': instance.sizeMB,
      'extension': instance.extension,
    };
