import 'package:blog_app/data/models/user/user_response_model.dart';

abstract class UserRepository {
  Future<UserResponseModel> getUser();
}
