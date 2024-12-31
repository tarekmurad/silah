library login_param;

import 'package:json_annotation/json_annotation.dart';

part 'login_param.g.dart';

@JsonSerializable()
class LoginParam {
  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'password')
  String? password;

  LoginParam({required this.email, required this.password});

  factory LoginParam.fromJson(Map<String, dynamic> json) =>
      _$LoginParamFromJson(json);

  Map<String, dynamic> toJson() => _$LoginParamToJson(this);
}
