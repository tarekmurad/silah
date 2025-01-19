// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_folder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalFolderModel _$GoalFolderModelFromJson(Map<String, dynamic> json) =>
    GoalFolderModel(
      folder: json['folder'] == null
          ? null
          : Folder.fromJson(json['folder'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GoalFolderModelToJson(GoalFolderModel instance) =>
    <String, dynamic>{
      'folder': instance.folder,
    };
