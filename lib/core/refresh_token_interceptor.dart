import 'dart:convert';
import 'package:blog_app/constants/api_constants.dart';
import 'package:blog_app/data/datasource/local_data_source/auth/auth_local_data_source.dart';
import 'package:blog_app/data/datasource/local_data_source/token/token_local_data_source.dart';
import 'package:blog_app/data/models/refreshToken/refresh_token_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@injectable
class RefreshTokenInterceptor extends Interceptor {
  final TokenLocalDataSource _tokenStorage;
  final AuthLocalDataSource _authLocalDataSource;

  RefreshTokenInterceptor(this._tokenStorage, this._authLocalDataSource);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await _addTokenIfNeeded(options);
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    _debugPrint('🔁 Detected 401 – Attempting token refresh');

    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      return handler.next(err);
    }

    _debugPrint('🔁 Refresh token:$refreshToken');

    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.authUrlEndpoint}/refresh-token',
      );
      _debugPrint(
        '🔁 Adding refreshToken: ${jsonEncode({'refreshToken': refreshToken})}',
      );
      final httpResponse = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      _debugPrint('🔁 Refresh response status: ${httpResponse.statusCode}');
      _debugPrint('🔁 Refresh response body: ${httpResponse.body}');

      if (httpResponse.statusCode != 200) {
        throw Exception('Failed to refresh token');
      }

      final refreshData = RefreshTokenResponseModel.fromJson(
        jsonDecode(httpResponse.body),
      );
      final newAccessToken = refreshData.accessToken!;

      await _tokenStorage.cacheAccessToken(newAccessToken);

      _debugPrint('✅ Token refresh successful – Retrying request');

      // Retry the original request
      final newRequest = err.requestOptions;
      newRequest.headers['Authorization'] = 'Bearer $newAccessToken';

      final dio = Dio(); // raw dio to retry
      final retryResponse = await dio.fetch(newRequest);
      return handler.resolve(retryResponse);
    } catch (e) {
      _debugPrint('❌ Token refresh failed – Logging out');
      await _tokenStorage.deleteAllTokens();
      await _authLocalDataSource.deleteUser();
      return handler.next(err);
    }
  }

  Future<void> _addTokenIfNeeded(RequestOptions options) async {
    if (options.headers.containsKey('Authorization')) return;

    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  void _debugPrint(String message) {
    if (kDebugMode) print(message);
  }
}
