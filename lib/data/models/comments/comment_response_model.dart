import 'package:json_annotation/json_annotation.dart';

part 'comment_response_model.g.dart';

@JsonSerializable()
class CommentResponseModel {
  @JsonKey(name: 'comments')
  List<Comment>? comments;
  CommentResponseModel({required this.comments});

  factory CommentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CommentResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentResponseModelToJson(this);
}

@JsonSerializable()
class Comment {
  @JsonKey(name: '_id')
  String? commentId;
  @JsonKey(name: 'blogId')
  String? blogId;
  @JsonKey(name: 'content')
  String? content;
  Comment({
    required this.commentId,
    required this.blogId,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
