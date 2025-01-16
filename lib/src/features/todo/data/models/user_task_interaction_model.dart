library user_task_interaction_model;

import 'package:json_annotation/json_annotation.dart';

part 'user_task_interaction_model.g.dart';

@JsonSerializable()
class UserTaskInteractionModel {
  @JsonKey(name: 'forDate')
  String? forDate;

  @JsonKey(name: 'record')
  int? record;

  UserTaskInteractionModel({
    this.forDate,
    this.record,
  });

  factory UserTaskInteractionModel.fromJson(Map<String, dynamic> json) =>
      _$UserTaskInteractionModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserTaskInteractionModelToJson(this);
}
