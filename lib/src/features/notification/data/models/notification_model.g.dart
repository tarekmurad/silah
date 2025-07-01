// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      userNotificationId: json['userNotificationId'] as String?,
    )
      ..notificationMessageId = json['notificationMessageId'] as String?
      ..title = json['title'] as String?
      ..body = json['body'] as String?
      ..category = json['category'] as String?
      ..senderType = json['senderType'] as String?
      ..scheduledAt = json['scheduledAt'] as String?
      ..readAt = json['readAt'] as String?
      ..linkExternal = json['linkExternal'] as String?
      ..notificationEndAt = json['notificationEndAt'] as String?;

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'userNotificationId': instance.userNotificationId,
      'notificationMessageId': instance.notificationMessageId,
      'title': instance.title,
      'body': instance.body,
      'category': instance.category,
      'senderType': instance.senderType,
      'scheduledAt': instance.scheduledAt,
      'readAt': instance.readAt,
      'linkExternal': instance.linkExternal,
      'notificationEndAt': instance.notificationEndAt,
    };
