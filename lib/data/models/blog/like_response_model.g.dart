// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeResponseModel _$LikeResponseModelFromJson(Map<String, dynamic> json) =>
    LikeResponseModel(
      blogId: json['blogId'] as String,
      likesCount: (json['likesCount'] as num).toInt(),
    );

Map<String, dynamic> _$LikeResponseModelToJson(LikeResponseModel instance) =>
    <String, dynamic>{
      'blogId': instance.blogId,
      'likesCount': instance.likesCount,
    };
