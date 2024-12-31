// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectResponse _$ObjectResponseFromJson(Map<String, dynamic> json) =>
    ObjectResponse(
      code: (json['code'] as num?)?.toInt(),
    )
      ..message = json['message'] as String?
      ..data = json['data'] as Map<String, dynamic>?;

Map<String, dynamic> _$ObjectResponseToJson(ObjectResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
