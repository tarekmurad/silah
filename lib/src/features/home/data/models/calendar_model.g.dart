// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarModel _$CalendarModelFromJson(Map<String, dynamic> json) =>
    CalendarModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      link: json['link'] as String?,
      start: json['start'] as String?,
      end: json['end'] as String?,
      allDay: json['roles'] as bool?,
    );

Map<String, dynamic> _$CalendarModelToJson(CalendarModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'desc': instance.desc,
      'link': instance.link,
      'start': instance.start,
      'end': instance.end,
      'roles': instance.allDay,
    };
