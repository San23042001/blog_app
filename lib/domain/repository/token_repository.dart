import 'package:blog_app/data/models/refreshToken/refresh_token_response_model.dart';

abstract class TokenRepository {
  Future<RefreshTokenResponseModel> refreshToken(Map<String, dynamic> params);

}