library object_response;

import 'package:json_annotation/json_annotation.dart';

part 'object_response.g.dart';

@JsonSerializable()
class ObjectResponse {
  int? code;
  String? message;
  Map<String, dynamic>? data;

  ObjectResponse({this.code});

  factory ObjectResponse.fromJson(Map<String, dynamic> json) =>
      _$ObjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ObjectResponseToJson(this);

  List<Object?> get props => [code, message];
}
