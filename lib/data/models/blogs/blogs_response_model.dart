import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blogs_response_model.g.dart';

@JsonSerializable()
class BlogsResponseModel {
  @JsonKey(name: 'blogs')
  final List<Blogs> blogs;

  BlogsResponseModel({required this.blogs});

  factory BlogsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BlogsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlogsResponseModelToJson(this);
}

