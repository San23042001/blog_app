// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogResponseModel _$BlogResponseModelFromJson(Map<String, dynamic> json) =>
    BlogResponseModel(
      blog: Blogs.fromJson(json['blog'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlogResponseModelToJson(BlogResponseModel instance) =>
    <String, dynamic>{'blog': instance.blog};

Blogs _$BlogsFromJson(Map<String, dynamic> json) => Blogs(
  title: json['title'] as String?,
  content: json['content'] as String?,
  banner:
      json['banner'] == null
          ? null
          : Banner.fromJson(json['banner'] as Map<String, dynamic>),
  author: json['author'] as String?,
  viewsCount: (json['viewsCount'] as num?)?.toInt(),
  likesCount: (json['likesCount'] as num?)?.toInt(),
  commentsCount: (json['commentsCount'] as num?)?.toInt(),
  status: json['status'] as String?,
  slug: json['slug'] as String?,
);

Map<String, dynamic> _$BlogsToJson(Blogs instance) => <String, dynamic>{
  'title': instance.title,
  'content': instance.content,
  'banner': instance.banner,
  'author': instance.author,
  'viewsCount': instance.viewsCount,
  'likesCount': instance.likesCount,
  'commentsCount': instance.commentsCount,
  'status': instance.status,
  'slug': instance.slug,
};

Banner _$BannerFromJson(Map<String, dynamic> json) => Banner(
  publicId: json['publicId'] as String?,
  url: json['url'] as String?,
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
);

Map<String, dynamic> _$BannerToJson(Banner instance) => <String, dynamic>{
  'publicId': instance.publicId,
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
};
