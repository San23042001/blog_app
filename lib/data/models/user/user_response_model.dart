import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_response_model.g.dart';

@JsonSerializable()
class UserResponseModel {
  @JsonKey(name: 'user')
  User? user;
  @JsonKey(name: 'accessToken')
  String? accessToken;
  @JsonKey(name: 'refreshToken')
  String? refreshToken;
  UserResponseModel({required this.user, required this.accessToken,required this.refreshToken});

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 0)
class User {
  @HiveField(0)
  @JsonKey(name: "_id")
   String? userId;
  @HiveField(1)
  @JsonKey(name: "username")
  final String username;
  @HiveField(2)
  @JsonKey(name: "email")
  final String email;
  @HiveField(3)
  @JsonKey(name: "role")
  final String role;
  User({this.userId,required this.username, required this.email, required this.role});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
