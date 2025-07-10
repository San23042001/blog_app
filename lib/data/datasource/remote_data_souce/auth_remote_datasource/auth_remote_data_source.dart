import 'package:blog_app/constants/api_constants.dart';
import 'package:blog_app/core/dio_client.dart';
import 'package:blog_app/data/models/user/user_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Future<UserResponseModel> register(Map<String, dynamic> params);
  Future<UserResponseModel> login(Map<String, dynamic> params);
  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImpl(this._client);
  @override
  Future<UserResponseModel> login(Map<String, dynamic> params) async {
    final userResponse = await _client.post(
      '${ApiConstants.baseUrl}${ApiConstants.authUrlEndpoint}/login',
      data: params,
    );
    return UserResponseModel.fromJson(userResponse.data);
  }

  @override
  Future<UserResponseModel> register(Map<String, dynamic> params) async {
    final userResponse = await _client.post(
      '${ApiConstants.baseUrl}${ApiConstants.authUrlEndpoint}/register',
      data: params,
    );
    return UserResponseModel.fromJson(userResponse.data);
  }

  @override
  Future<void> logout() async {
    await _client.post(
      '${ApiConstants.baseUrl}${ApiConstants.authUrlEndpoint}/logout',
    );
  }
  

}
