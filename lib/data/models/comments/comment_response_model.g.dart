// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentResponseModel _$CommentResponseModelFromJson(
  Map<String, dynamic> json,
) => CommentResponseModel(
  comments:
      (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$CommentResponseModelToJson(
  CommentResponseModel instance,
) => <String, dynamic>{'comments': instance.comments};

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
  commentId: json['_id'] as String?,
  blogId: json['blogId'] as String?,
  content: json['content'] as String?,
);

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
  '_id': instance.commentId,
  'blogId': instance.blogId,
  'content': instance.content,
};
