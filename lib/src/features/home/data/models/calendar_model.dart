library calendar;

import 'package:json_annotation/json_annotation.dart';

part 'calendar_model.g.dart';

@JsonSerializable()
class CalendarModel {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'desc')
  String? desc;

  @JsonKey(name: 'link')
  String? link;

  @JsonKey(name: 'start')
  String? start;

  @JsonKey(name: 'end')
  String? end;

  @JsonKey(name: 'roles')
  bool? allDay;

  CalendarModel({
    this.id,
    this.title,
    this.desc,
    this.link,
    this.start,
    this.end,
    this.allDay,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarModelToJson(this);
}
