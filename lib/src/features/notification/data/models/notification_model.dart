library Notification;

import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
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

  @JsonKey(name: 'notificationEndAt')
  String? notificationEndAt;

  NotificationModel({
    this.userNotificationId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
