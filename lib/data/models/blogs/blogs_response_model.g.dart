// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blogs_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogsResponseModel _$BlogsResponseModelFromJson(Map<String, dynamic> json) =>
    BlogsResponseModel(
      blogs:
          (json['blogs'] as List<dynamic>)
              .map((e) => Blogs.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$BlogsResponseModelToJson(BlogsResponseModel instance) =>
    <String, dynamic>{'blogs': instance.blogs};
