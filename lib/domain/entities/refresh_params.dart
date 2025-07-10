import 'package:json_annotation/json_annotation.dart';

part 'refresh_params.g.dart';

@JsonSerializable()
class RefreshParams {
  @JsonKey(name: 'refreshToken')
  final String refreshToken;

  RefreshParams({required this.refreshToken});

  factory RefreshParams.fromJson(Map<String, dynamic> json) =>
      _$RefreshParamsFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshParamsToJson(this);
}
