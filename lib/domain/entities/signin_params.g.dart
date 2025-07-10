// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SigninParams _$SigninParamsFromJson(Map<String, dynamic> json) => SigninParams(
  email: json['email'] as String,
  password: json['password'] as String,
  role: json['role'] as String? ?? 'user',
);

Map<String, dynamic> _$SigninParamsToJson(SigninParams instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
    };
