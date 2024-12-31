// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FolderAdapter extends TypeAdapter<Folder> {
  @override
  final int typeId = 0;

  @override
  Folder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Folder(
      id: fields[0] as String?,
      name: fields[1] as String?,
      desc: fields[2] as String?,
      type: fields[3] as String?,
      path: fields[4] as String?,
      parentId: fields[5] as String?,
      children: (fields[6] as List?)?.cast<Folder>(),
      mediaFiles: (fields[7] as List?)?.cast<MediaFile>(),
      progress: fields[8] as int?,
      isFavorite: fields[9] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Folder obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.path)
      ..writeByte(5)
      ..write(obj.parentId)
      ..writeByte(6)
      ..write(obj.children)
      ..writeByte(7)
      ..write(obj.mediaFiles)
      ..writeByte(8)
      ..write(obj.progress)
      ..writeByte(9)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Folder _$FolderFromJson(Map<String, dynamic> json) => Folder(
      id: json['id'] as String?,
      name: json['name'] as String?,
      desc: json['desc'] as String?,
      type: json['type'] as String?,
      path: json['path'] as String?,
      parentId: json['parentId'] as String?,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => Folder.fromJson(e as Map<String, dynamic>))
          .toList(),
      mediaFiles: (json['mediaFiles'] as List<dynamic>?)
          ?.map((e) => MediaFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      progress: (json['progress'] as num?)?.toInt(),
      isFavorite: json['isFavorite'] as bool?,
    );

Map<String, dynamic> _$FolderToJson(Folder instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'type': instance.type,
      'path': instance.path,
      'parentId': instance.parentId,
      'children': instance.children,
      'mediaFiles': instance.mediaFiles,
      'progress': instance.progress,
      'isFavorite': instance.isFavorite,
    };
