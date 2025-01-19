library media_file;

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'media_file.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class MediaFile extends HiveObject {
  @JsonKey(name: 'id')
  @HiveField(0)
  String? id;

  @JsonKey(name: 'type')
  @HiveField(1)
  String? type;

  @JsonKey(name: 'attribute')
  @HiveField(2)
  String? attribute;

  @JsonKey(name: 'sizeMB')
  @HiveField(3)
  double? sizeMB;

  @JsonKey(name: 'extension')
  @HiveField(4)
  String? extension;

  MediaFile({
    this.id,
    this.type,
    this.attribute,
    this.sizeMB,
    this.extension,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) =>
      _$MediaFileFromJson(json);

  Map<String, dynamic> toJson() => _$MediaFileToJson(this);
}
