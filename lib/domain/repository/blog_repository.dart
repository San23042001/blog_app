import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:blog_app/data/models/blog/like_response_model.dart';
import 'package:blog_app/data/models/blogs/blogs_response_model.dart';
import 'package:dio/dio.dart';

abstract class BlogRepository {
  Future<BlogResponseModel> createBlog(FormData formData);
  Future<BlogsResponseModel> getAllBlogs(Map<String, dynamic> params);
  Future<LikeResponseModel> likeBlog(
    Map<String, dynamic> params,
    String blogId,
  );
  Future<void> dislikeBlog(Map<String, dynamic> params, String blogId);
}
