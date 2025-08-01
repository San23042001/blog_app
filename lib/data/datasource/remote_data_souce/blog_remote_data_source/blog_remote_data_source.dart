import 'package:blog_app/constants/api_constants.dart';
import 'package:blog_app/core/dio_client.dart';
import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:blog_app/data/models/blog/like_response_model.dart';
import 'package:blog_app/data/models/blogs/blogs_response_model.dart';
import 'package:blog_app/data/models/comments/comment_response_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class BlogRemoteDataSource {
  Future<BlogResponseModel> createBlog(FormData formData);
  Future<BlogsResponseModel> getAllBlogs(Map<String, dynamic> params);
  Future<LikeResponseModel> likeBlog(
    Map<String, dynamic> params,
    String blogId,
  );
  Future<void> dislikeBlog(Map<String, dynamic> params, String blogId);
  Future<CommentResponseModel> fetchCommentsByBlogId(String blogId);
  Future<Comment> createComment(Map<String, dynamic> params, String blogId);
}

@LazySingleton(as: BlogRemoteDataSource)
class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final DioClient _client;

  BlogRemoteDataSourceImpl(this._client);

  @override
  Future<BlogResponseModel> createBlog(FormData formData) async {
    final response = await _client.post(
      '${ApiConstants.baseUrl}/blogs',
      data: formData,
    );

    return BlogResponseModel.fromJson(response.data);
  }

  @override
  Future<BlogsResponseModel> getAllBlogs(Map<String, dynamic> params) async {
    final response = await _client.get(
      '${ApiConstants.baseUrl}/blogs',
      queryParams: params,
    );
    return BlogsResponseModel.fromJson(response.data);
  }

  @override
  Future<LikeResponseModel> likeBlog(
    Map<String, dynamic> params,
    String blogId,
  ) async {
    final response = await _client.post(
      '${ApiConstants.baseUrl}/likes/blog/$blogId',
      data: params,
    );
    return LikeResponseModel.fromJson(response.data);
  }

  @override
  Future<void> dislikeBlog(Map<String, dynamic> params, String blogId) async {
    await _client.delete(
      '${ApiConstants.baseUrl}/likes/blog/$blogId',
      data: params,
    );
  }

  @override
  Future<CommentResponseModel> fetchCommentsByBlogId(String blogId) async {
    final response = await _client.get(
      '${ApiConstants.baseUrl}/comments/blog/$blogId',
    );

    return CommentResponseModel.fromJson(response.data);
  }

  @override
  Future<Comment> createComment(
    Map<String, dynamic> params,
    String blogId,
  ) async {
    final response = await _client.post(
      '${ApiConstants.baseUrl}/comments/blog/$blogId',
      data: params,
    );
    return Comment.fromJson(response.data);
  }
}
