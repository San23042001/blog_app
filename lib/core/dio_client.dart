import 'package:blog_app/core/network_exception.dart';
import 'package:blog_app/core/token_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../app_logger.dart';

@lazySingleton
class DioClient {
  final Dio _dio;

  DioClient(TokenInterceptor tokenInterceptor) : _dio = Dio() {
    _dio.interceptors.add(tokenInterceptor);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    logger.i("Request send to path:$path");
    try {
      return await _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      logger.e("GET request failed: $path Error $e");
      throw NetworkExceptions.getDioException(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    logger.i("Request sent to path: $path");

    try {
      return await _dio.post(
        path,
        data: data,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      logger.e("POST request failed: $path Error: $e Data: $data");
      throw NetworkExceptions.getDioException(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    logger.i("Request send to path:$path");
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      logger.e("PUT request failed:$path Error $e");
      throw NetworkExceptions.getDioException(e);
    }
  }

  Future<Response> delete(String path, {dynamic data}) async {
    logger.i("Request send to path:$path");
    try {
      return await _dio.delete(path, data: data);
    } on DioException catch (e) {
      logger.e("DELETE request failed: $path Error $e");
      throw NetworkExceptions.getDioException(e);
    }
  }
}
