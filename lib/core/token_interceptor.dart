import 'package:blog_app/app_logger.dart';
import 'package:blog_app/constants/api_constants.dart';
import 'package:blog_app/data/datasource/local_data_source/auth/auth_local_data_source.dart';
import 'package:blog_app/data/datasource/local_data_source/token/token_local_data_source.dart';
import 'package:blog_app/data/models/refreshToken/refresh_token_response_model.dart';
import 'package:blog_app/domain/entities/refresh_params.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class TokenInterceptor extends Interceptor {
  final Dio _dio; // Main Dio instance
  final Dio _refreshDio; // Separate Dio for refresh
  final TokenLocalDataSource _tokenStorage;
  final AuthLocalDataSource _authLocalDataSource;

  TokenInterceptor(
    this._dio,
    @Named('refreshDio') this._refreshDio,
    this._tokenStorage,
    this._authLocalDataSource,
  );

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.i('🚨Detected 401 – Attempting token refresh');

    // Only handle if unauthorized
    if (err.response?.statusCode == 401) {
      final refreshToken = await _tokenStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        logger.e('❌ No refresh token found');
        await _handleLogout(handler, err);
        return;
      }

      try {
        logger.i('🔄 Attempting token refresh');

        final refreshParams = RefreshParams(refreshToken: refreshToken);

        final response = await _refreshDio.post(
          '${ApiConstants.authUrlEndpoint}/refresh-token',
          data: refreshParams.toJson(),
        );

        final newAccessToken = RefreshTokenResponseModel.fromJson(
          response.data,
        ).accessToken;

        if (newAccessToken == null || newAccessToken.isEmpty) {
          logger.e('❌ New access token missing');
          await _handleLogout(handler, err);
          return;
        }

        // Cache new token
        await _tokenStorage.cacheAccessToken(newAccessToken);
        logger.i('✅ New Access Token Cached');

        // Retry the original request
        final RequestOptions requestOptions = err.requestOptions;

        // Set new token in headers
        requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        if (requestOptions.data is FormData) {
          logger.e(
            '❌ Cannot retry request with FormData. Please resubmit manually.',
          );

          // Pass error to UI to allow user action
          handler.reject(
            DioException(
              requestOptions: requestOptions,
              error: 'Session expired. Please resubmit your form.',
              type: DioExceptionType.unknown,
            ),
          );
          return;
        }

        logger.i('🔁 Retrying request to ${requestOptions.uri}');

        final retryResponse = await _dio.fetch(requestOptions);

        return handler.resolve(retryResponse);
      } catch (refreshError) {
        logger.e('❌ Token refresh failed: $refreshError');
        await _handleLogout(handler, err);
        return;
      }
    }

    // Pass through any other errors
    handler.next(err);
  }

  Future<void> _handleLogout(
    ErrorInterceptorHandler handler,
    DioException err,
  ) async {
    await _tokenStorage.deleteAllTokens();
    await _authLocalDataSource.deleteUser();
    logger.i('🚪 Logged out due to token failure');
    handler.next(err);
  }
}
