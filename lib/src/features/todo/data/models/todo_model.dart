library calendar;

import 'package:boilerplate_flutter/src/features/todo/data/models/user_task_interaction_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../auth/data/models/role_model.dart';
import 'goal_folder_model.dart';
import 'goal_model.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'desc')
  String? desc;

  @JsonKey(name: 'goalType')
  String? goalType;

  @JsonKey(name: 'priority')
  String? priority;

  @JsonKey(name: 'notifyTime')
  String? notifyTime;

  @JsonKey(name: 'startRange')
  String? startRange;

  @JsonKey(name: 'endRange')
  String? endRange;

  @JsonKey(name: 'recurrence')
  String? recurrence;

  @JsonKey(name: 'exceptions')
  List<String>? exceptions;

  @JsonKey(
      name: 'goalDetails',
      fromJson: _goalDetailsFromJson,
      toJson: _goalDetailsToJson)
  dynamic goalDetails;

  @JsonKey(name: 'createdAt')
  String? createdAt;

  @JsonKey(name: 'circles')
  List<RoleModel>? circles;

  @JsonKey(name: 'userTaskInteractions')
  List<UserTaskInteractionModel>? userTaskInteractions;

  TodoModel({
    this.id,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  // Helper methods for goalDetails
  static dynamic _goalDetailsFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    // Detect structure based on key or fields
    if (json.containsKey('counterGoal')) {
      return GoalModel.fromJson(json);
    } else if (json.containsKey('folder')) {
      return GoalFolderModel.fromJson(json);
    }

    throw Exception("Unknown goalDetails structure: $json");
  }

  static Map<String, dynamic>? _goalDetailsToJson(dynamic goalDetails) {
    if (goalDetails == null) return null;

    if (goalDetails is GoalModel) {
      return goalDetails.toJson();
    } else if (goalDetails is GoalFolderModel) {
      return goalDetails.toJson();
    }

    throw Exception("Unknown goalDetails type: $goalDetails");
  }
}
