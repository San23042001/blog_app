import 'package:blog_app/constants/api_constants.dart';
import 'package:blog_app/core/dio_client.dart';
import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:blog_app/domain/entities/blog_params.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class BlogRemoteDataSource {
  Future<BlogResponseModel> createBlog(BlogParam param);
}

@LazySingleton(as: BlogRemoteDataSource)
class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final DioClient _client;

  BlogRemoteDataSourceImpl(this._client);

  @override
  Future<BlogResponseModel> createBlog(BlogParam param) async {
    final formData = FormData.fromMap({
      'title': param.title,
      'content': param.content,
      'status': param.status,
      'banner_image': await MultipartFile.fromFile(
        param.bannerImage.path,
        filename: param.bannerImage.path.split('/').last,
      ),
    });

    final response = await _client.post(
      '${ApiConstants.baseUrl}/blogs',
      data: formData,
    );

    return BlogResponseModel.fromJson(response.data);
  }
}
