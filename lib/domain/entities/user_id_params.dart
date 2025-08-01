import 'package:json_annotation/json_annotation.dart';

part 'user_id_params.g.dart';

@JsonSerializable()
class UserIdParams {
  @JsonKey(name: 'userId')
   String? userId;

  UserIdParams({this.userId});

  factory UserIdParams.fromJson(Map<String, dynamic> json) =>
      _$UserIdParamsFromJson(json);

  Map<String, dynamic> toJson() => _$UserIdParamsToJson(this);
}
