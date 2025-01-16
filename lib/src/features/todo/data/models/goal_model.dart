library goal;

import 'package:json_annotation/json_annotation.dart';

part 'goal_model.g.dart';

@JsonSerializable()
class GoalModel {
  @JsonKey(name: 'counterGoal')
  int? counterGoal;

  @JsonKey(name: 'counterMin')
  int? counterMin;

  GoalModel({
    this.counterGoal,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) =>
      _$GoalModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoalModelToJson(this);
}
