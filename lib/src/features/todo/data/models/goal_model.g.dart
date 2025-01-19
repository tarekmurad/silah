// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalModel _$GoalModelFromJson(Map<String, dynamic> json) => GoalModel(
      counterGoal: (json['counterGoal'] as num?)?.toInt(),
    )..counterMin = (json['counterMin'] as num?)?.toInt();

Map<String, dynamic> _$GoalModelToJson(GoalModel instance) => <String, dynamic>{
      'counterGoal': instance.counterGoal,
      'counterMin': instance.counterMin,
    };
