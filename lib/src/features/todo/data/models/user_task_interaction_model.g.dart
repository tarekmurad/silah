// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_task_interaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTaskInteractionModel _$UserTaskInteractionModelFromJson(
        Map<String, dynamic> json) =>
    UserTaskInteractionModel(
      forDate: json['forDate'] as String?,
      record: (json['record'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserTaskInteractionModelToJson(
        UserTaskInteractionModel instance) =>
    <String, dynamic>{
      'forDate': instance.forDate,
      'record': instance.record,
    };
