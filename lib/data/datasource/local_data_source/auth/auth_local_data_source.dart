import 'package:blog_app/app_logger.dart';
import 'package:blog_app/constants/hive_constants.dart';
import 'package:blog_app/data/models/user/user_response_model.dart';
import 'package:blog_app/logger.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const String _h = 'auth_local_service';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(User user);
  Future<void> deleteUser();
  Future<User?> getUser();
  Future<String?> getUserId();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> cacheUser(User user) async {
    final Box box = await Hive.openBox(HiveConstants.userBoxName);
    await box.put(HiveConstants.userKey, user);
    await box.put(HiveConstants.userIdKey, user.userId);
    logInfo(_h, "User cached successfully");
  }

  @override
  Future<void> deleteUser() async {
    final box = await Hive.openBox(HiveConstants.userBoxName);
    await box.delete(HiveConstants.userKey);
    await box.delete(HiveConstants.userIdKey);
  }

  @override
  Future<User?> getUser() async {
    logger.d("GetCachedUser");
    final box = await Hive.openBox(HiveConstants.userBoxName);
    return box.get(HiveConstants.userKey);
  }

  @override
  Future<String?> getUserId() async {
    final box = await Hive.openBox(HiveConstants.userBoxName);
    return box.get(HiveConstants.userIdKey) as String?;
  }
}
