import 'package:json_annotation/json_annotation.dart';
part 'like_response_model.g.dart';

@JsonSerializable()
class LikeResponseModel {
  @JsonKey(name: 'blogId')
  final String blogId;

  @JsonKey(name: 'likesCount')
  final int likesCount;

  LikeResponseModel({
    required this.blogId,
    required this.likesCount,
  });

  factory LikeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LikeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LikeResponseModelToJson(this);
}

