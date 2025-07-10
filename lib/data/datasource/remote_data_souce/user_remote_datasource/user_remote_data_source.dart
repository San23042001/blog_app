import 'package:blog_app/constants/api_constants.dart';
import 'package:blog_app/core/dio_client.dart';
import 'package:blog_app/data/models/user/user_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class UserRemoteDataSource {
  Future<UserResponseModel> getUser();
}
@LazySingleton(as:UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _client;

  UserRemoteDataSourceImpl(this._client);
  @override
  Future<UserResponseModel> getUser() async {
    final userData = await _client.get('${ApiConstants.baseUrl}/users/current');
    return UserResponseModel.fromJson(userData.data);
  }
}
