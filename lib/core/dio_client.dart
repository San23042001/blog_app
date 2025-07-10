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
    final startTime = DateTime.now();
    logger.i("GET Request sent to path: $path");

    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      logger.i("GET Response received from $path in ${duration}ms");
      return response;
    } on DioException catch (e) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      logger.e("GET request failed: $path in ${duration}ms. Error: $e");
      throw NetworkExceptions.getDioException(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    final startTime = DateTime.now();
    logger.i("POST Request sent to path: $path");

    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(headers: headers),
      );
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      logger.i("POST Response received from $path in ${duration}ms");
      return response;
    } on DioException catch (e) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      logger.e("POST request failed: $path in ${duration}ms. Error: $e Data: $data");
      throw NetworkExceptions.getDioException(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    final startTime = DateTime.now();
    logger.i("PUT Request sent to path: $path");

    try {
      final response = await _dio.put(path, data: data);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      logger.i("PUT Response received from $path in ${duration}ms");
      return response;
    } on DioException catch (e) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      logger.e("PUT request failed: $path in ${duration}ms. Error: $e");
      throw NetworkExceptions.getDioException(e);
    }
  }

  Future<Response> delete(String path, {dynamic data}) async {
    final startTime = DateTime.now();
    logger.i("DELETE Request sent to path: $path");

    try {
      final response = await _dio.delete(path, data: data);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      logger.i("DELETE Response received from $path in ${duration}ms");
      return response;
    } on DioException catch (e) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      logger.e("DELETE request failed: $path in ${duration}ms. Error: $e");
      throw NetworkExceptions.getDioException(e);
    }
  }
}
