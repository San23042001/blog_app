import 'package:blog_app/data/datasource/remote_data_souce/blog_remote_data_source/blog_remote_data_source.dart';

import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:blog_app/data/models/blog/like_response_model.dart';
import 'package:blog_app/data/models/blogs/blogs_response_model.dart';
import 'package:blog_app/data/models/comments/comment_response_model.dart';

import 'package:blog_app/domain/repository/blog_repository.dart';
import 'package:dio/dio.dart';

import 'package:injectable/injectable.dart';

@LazySingleton(as: BlogRepository)
class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource _blogRemoteDataSource;

  BlogRepositoryImpl(this._blogRemoteDataSource);

  @override
  Future<BlogResponseModel> createBlog(FormData formData) async {
    return await _blogRemoteDataSource.createBlog(formData);
  }

  @override
  Future<BlogsResponseModel> getAllBlogs(Map<String, dynamic> params) async {
    return await _blogRemoteDataSource.getAllBlogs(params);
  }

  @override
  Future<LikeResponseModel> likeBlog(
    Map<String, dynamic> params,
    String blogId,
  ) async {
    return await _blogRemoteDataSource.likeBlog(params, blogId);
  }

  @override
  Future<void> dislikeBlog(Map<String, dynamic> params, String blogId) async {
    await _blogRemoteDataSource.dislikeBlog(params, blogId);
  }

  @override
  Future<CommentResponseModel> fetchCommentsByBlogId(String blogId) async {
    return await _blogRemoteDataSource.fetchCommentsByBlogId(blogId);
  }

  @override
  Future<Comment> createComment(
    Map<String, dynamic> params,
    String blogId,
  ) async {
    return await _blogRemoteDataSource.createComment(params, blogId);
  }
}
