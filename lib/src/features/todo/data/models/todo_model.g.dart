// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) => TodoModel(
      id: json['id'] as String?,
    )
      ..title = json['title'] as String?
      ..desc = json['desc'] as String?
      ..goalType = json['goalType'] as String?
      ..priority = json['priority'] as String?
      ..notifyTime = json['notifyTime'] as String?
      ..startRange = json['startRange'] as String?
      ..endRange = json['endRange'] as String?
      ..recurrence = json['recurrence'] as String?
      ..exceptions = (json['exceptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..goalDetails = TodoModel._goalDetailsFromJson(
          json['goalDetails'] as Map<String, dynamic>?)
      ..createdAt = json['createdAt'] as String?
      ..circles = (json['circles'] as List<dynamic>?)
          ?.map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..userTaskInteractions = (json['userTaskInteractions'] as List<dynamic>?)
          ?.map((e) =>
              UserTaskInteractionModel.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$TodoModelToJson(TodoModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'desc': instance.desc,
      'goalType': instance.goalType,
      'priority': instance.priority,
      'notifyTime': instance.notifyTime,
      'startRange': instance.startRange,
      'endRange': instance.endRange,
      'recurrence': instance.recurrence,
      'exceptions': instance.exceptions,
      'goalDetails': TodoModel._goalDetailsToJson(instance.goalDetails),
      'createdAt': instance.createdAt,
      'circles': instance.circles,
      'userTaskInteractions': instance.userTaskInteractions,
    };
