import 'package:json_annotation/json_annotation.dart';

part 'comment_params.g.dart';

@JsonSerializable()
class CommentParams {
  @JsonKey(name: 'content')
  final String content;

  CommentParams({required this.content});

  factory CommentParams.fromJson(Map<String, dynamic> json) =>
      _$CommentParamsFromJson(json);

  Map<String, dynamic> toJson() => _$CommentParamsToJson(this);
}
