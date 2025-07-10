import 'package:blog_app/constants/hive_constants.dart';
import 'package:blog_app/logger.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const String _h = 'token_service';

abstract class TokenLocalDataSource {
  Future<void> cacheAccessToken(String token);

  Future<void> cacheRefreshToken(String token);

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> deleteAccessToken();

  Future<void> deleteRefreshToken();

  Future<void> deleteAllTokens();
}

@LazySingleton(as: TokenLocalDataSource)
class TokenLocalDataSourceImpl implements TokenLocalDataSource {
  @override
  Future<void> cacheAccessToken(String token) async {
    logInfo(_h, "cache access Token : $token");
    final box = await Hive.openBox(HiveConstants.tokenBoxName);
    await box.put(HiveConstants.accessTokenKey, token);
  }

  @override
  Future<void> cacheRefreshToken(String token) async {
    logInfo(_h, "cache refresh Token : $token");

    final box = await Hive.openBox(HiveConstants.tokenBoxName);
    await box.put(HiveConstants.refreshTokenKey, token);
  }

  @override
  Future<void> deleteAccessToken() async {
    logInfo(_h, "delete access Token");
    final box = await Hive.openBox(HiveConstants.tokenBoxName);
    await box.delete(HiveConstants.accessTokenKey);
  }

  @override
  Future<void> deleteAllTokens() async {
    logInfo(_h, "delete all Tokens");
    final box = await Hive.openBox(HiveConstants.tokenBoxName);
    await box.deleteAll(
      [HiveConstants.accessTokenKey, HiveConstants.refreshTokenKey],
    );
  }

  @override
  Future<void> deleteRefreshToken() async {
    logInfo(_h, "delete refresh Token");
    final box = await Hive.openBox(HiveConstants.tokenBoxName);
    await box.delete(HiveConstants.refreshTokenKey);
  }

  @override
  Future<String?> getAccessToken() async {
    final box = await Hive.openBox(HiveConstants.tokenBoxName);
    return box.get(HiveConstants.accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    final box = await Hive.openBox(HiveConstants.tokenBoxName);
    return box.get(HiveConstants.refreshTokenKey);
  }
}