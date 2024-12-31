library update_firebase_token_param;

import 'package:json_annotation/json_annotation.dart';

part 'update_firebase_token_param.g.dart';

@JsonSerializable()
class UpdateFirebaseTokenParam {
  @JsonKey(name: 'firebaseToken')
  String? firebaseToken;

  @JsonKey(name: 'deviceId')
  String? deviceId;

  UpdateFirebaseTokenParam(
      {required this.firebaseToken, required this.deviceId});

  factory UpdateFirebaseTokenParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateFirebaseTokenParamFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFirebaseTokenParamToJson(this);
}
