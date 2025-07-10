import 'package:blog_app/data/datasource/blog_remote_data_source/blog_remote_data_source.dart';

import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:blog_app/domain/entities/blog_params.dart';

import 'package:blog_app/domain/repository/blog_repository.dart';

import 'package:injectable/injectable.dart';

@LazySingleton(as: BlogRepository)
class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource _blogRemoteDataSource;

  BlogRepositoryImpl(this._blogRemoteDataSource);

  @override
  Future<BlogResponseModel> createBlog(BlogParam param) async {
    return await _blogRemoteDataSource.createBlog(param);
  }
}
