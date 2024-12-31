library folder;

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'media_file.dart';

part 'folder.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Folder extends HiveObject {
  @JsonKey(name: 'id')
  @HiveField(0)
  String? id;

  @JsonKey(name: 'name')
  @HiveField(1)
  String? name;

  @HiveField(2)
  @JsonKey(name: 'desc')
  String? desc;

  @HiveField(3)
  @JsonKey(name: 'type')
  String? type;

  @HiveField(4)
  @JsonKey(name: 'path')
  String? path;

  @HiveField(5)
  @JsonKey(name: 'parentId')
  String? parentId;

  @HiveField(6)
  @JsonKey(name: 'children')
  List<Folder>? children;

  @HiveField(7)
  @JsonKey(name: 'mediaFiles')
  List<MediaFile>? mediaFiles;

  @HiveField(8)
  @JsonKey(name: 'progress')
  int? progress;

  @HiveField(9)
  @JsonKey(name: 'isFavorite')
  bool? isFavorite;

  Folder({
    this.id,
    this.name,
    this.desc,
    this.type,
    this.path,
    this.parentId,
    this.children,
    this.mediaFiles,
    this.progress,
    this.isFavorite,
  });

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);

  Map<String, dynamic> toJson() => _$FolderToJson(this);
}
