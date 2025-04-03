library user;

import 'package:json_annotation/json_annotation.dart';
import 'package:silah_connect/src/features/auth/data/models/role_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'status')
  String? status;

  @JsonKey(name: 'circles')
  List<RoleModel>? circles;

  UserModel({
    this.email,
    this.name,
    this.status,
    this.circles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
