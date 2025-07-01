library Announcement;

import 'package:json_annotation/json_annotation.dart';

part 'announcement_model.g.dart';

@JsonSerializable()
class AnnouncementModel {
  @JsonKey(name: 'userNotificationId')
  String? userNotificationId;

  @JsonKey(name: 'notificationMessageId')
  String? notificationMessageId;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'body')
  String? body;

  @JsonKey(name: 'category')
  String? category;

  @JsonKey(name: 'senderType')
  String? senderType;

  @JsonKey(name: 'scheduledAt')
  String? scheduledAt;

  @JsonKey(name: 'readAt')
  String? readAt;

  @JsonKey(name: 'linkExternal')
  String? linkExternal;

  @JsonKey(name: 'announcementEndAt')
  String? announcementEndAt;

  AnnouncementModel({
    this.userNotificationId,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementModelToJson(this);
}
