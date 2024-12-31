library authentication;

import 'package:json_annotation/json_annotation.dart';

part 'authentication_model.g.dart';

@JsonSerializable()
class AuthenticationModel {
  @JsonKey(name: 'token')
  String? token;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'refreshToken')
  String? refreshToken;

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'username')
  String? username;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'roles')
  List<String>? roles;

  AuthenticationModel({
    this.token,
    this.type,
    this.refreshToken,
    this.id,
    this.username,
    this.email,
    this.roles,
  });

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationModelToJson(this);
}
