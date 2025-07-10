import 'package:json_annotation/json_annotation.dart';

part 'signin_params.g.dart';

@JsonSerializable()
class SigninParams {
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'role')
  String role;

  SigninParams({required this.email, required this.password,this.role='user'});

  factory SigninParams.fromJson(Map<String, dynamic> json) =>
      _$SigninParamsFromJson(json);

  Map<String, dynamic> toJson() => _$SigninParamsToJson(this);
}
