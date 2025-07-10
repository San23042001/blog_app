import 'package:blog_app/data/datasource/remote_data_souce/user_remote_datasource/user_remote_data_source.dart';
import 'package:blog_app/data/models/user/user_response_model.dart';
import 'package:blog_app/domain/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRepositoryImpl(this._userRemoteDataSource);

  @override
  Future<UserResponseModel> getUser() async {
    return await _userRemoteDataSource.getUser();
  }
}
