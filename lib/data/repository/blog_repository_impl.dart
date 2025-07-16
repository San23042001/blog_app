import 'package:blog_app/data/datasource/remote_data_souce/blog_remote_data_source/blog_remote_data_source.dart';

import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:blog_app/data/models/blogs/blogs_response_model.dart';

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
  Future<BlogsResponseModel> getAllBlogs(Map<String, dynamic> params) async{
    return await _blogRemoteDataSource.getAllBlogs(params);
  }
}
