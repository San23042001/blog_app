import 'package:blog_app/data/datasource/local_data_source/auth/auth_local_data_source.dart';
import 'package:blog_app/data/datasource/local_data_source/token/token_local_data_source.dart';
import 'package:blog_app/data/datasource/remote_data_souce/auth_remote_datasource/auth_remote_data_source.dart';
import 'package:blog_app/data/models/user/user_response_model.dart';
import 'package:blog_app/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  late final AuthRemoteDataSource _authRemoteDataSource;
  late final TokenLocalDataSource _tokenLocalDataSource;
  late final AuthLocalDataSource _authLocalDataSource;
  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._tokenLocalDataSource,
    this._authLocalDataSource,
  );
  @override
  Future<UserResponseModel> login(Map<String, dynamic> params) async {
    final userResponseModel = await _authRemoteDataSource.login(params);
    await _tokenLocalDataSource.cacheAccessToken(
      userResponseModel.accessToken!,
    );
    await _tokenLocalDataSource.cacheRefreshToken(
      userResponseModel.refreshToken!,
    );
    await _authLocalDataSource.cacheUser(userResponseModel.user!);

    return userResponseModel;
  }

  @override
  Future<UserResponseModel> register(Map<String, dynamic> params) async {
    final userResponseModel = await _authRemoteDataSource.register(params);
    await _tokenLocalDataSource.cacheAccessToken(
      userResponseModel.accessToken!,
    );
    await _tokenLocalDataSource.cacheRefreshToken(
      userResponseModel.refreshToken!,
    );
    await _authLocalDataSource.cacheUser(userResponseModel.user!);
    return userResponseModel;
  }

  @override
  Future<User?> getUser() async {
    final res = await _authLocalDataSource.getUser();
    return res;
  }

  @override
  Future<void> logout() async {
    await _authRemoteDataSource.logout();
    await _authLocalDataSource.deleteUser();
    await _tokenLocalDataSource.deleteAllTokens();
  }
}
