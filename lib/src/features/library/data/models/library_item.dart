library library_item;

import 'package:json_annotation/json_annotation.dart';

import 'folder.dart';

part 'library_item.g.dart';

@JsonSerializable()
class LibraryItem {
  @JsonKey(name: 'folders')
  List<Folder>? folders;

  LibraryItem({this.folders});

  factory LibraryItem.fromJson(Map<String, dynamic> json) =>
      _$LibraryItemFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryItemToJson(this);
}
