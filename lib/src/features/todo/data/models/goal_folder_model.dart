library goal_folder;

import 'package:json_annotation/json_annotation.dart';

import '../../../library/data/models/folder.dart';

part 'goal_folder_model.g.dart';

@JsonSerializable()
class GoalFolderModel {
  @JsonKey(name: 'folder')
  Folder? folder;

  GoalFolderModel({
    this.folder,
  });

  factory GoalFolderModel.fromJson(Map<String, dynamic> json) =>
      _$GoalFolderModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoalFolderModelToJson(this);
}
