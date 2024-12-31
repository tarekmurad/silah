// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryItem _$LibraryItemFromJson(Map<String, dynamic> json) => LibraryItem(
      folders: (json['folders'] as List<dynamic>?)
          ?.map((e) => Folder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LibraryItemToJson(LibraryItem instance) =>
    <String, dynamic>{
      'folders': instance.folders,
    };
