import 'package:blog_app/data/models/user/user_response_model.dart';

abstract class AuthRepository {
  Future<UserResponseModel> register(Map<String, dynamic> params);
  Future<UserResponseModel> login(Map<String, dynamic> params);
  Future<User?> getUser();
  Future<String?> getUserId();
  Future<void> logout();
}
