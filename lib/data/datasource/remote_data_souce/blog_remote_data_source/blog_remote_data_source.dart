import 'package:blog_app/constants/api_constants.dart';
import 'package:blog_app/core/dio_client.dart';
import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class BlogRemoteDataSource {
  Future<BlogResponseModel> createBlog(FormData formData);
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
}
