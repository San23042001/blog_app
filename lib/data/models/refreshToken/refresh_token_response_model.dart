import 'package:json_annotation/json_annotation.dart';
part 'refresh_token_response_model.g.dart';

@JsonSerializable()
class RefreshTokenResponseModel {
  @JsonKey(name: 'accessToken')
  String? accessToken;
  RefreshTokenResponseModel({required this.accessToken});

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseModelToJson(this);
}
