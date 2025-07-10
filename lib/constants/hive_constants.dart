class HiveConstants {
  HiveConstants._();

  // Hive box names
  static const String tokenBoxName = 'tokenBox';
  static const String userBoxName = 'userBox';
  static const String memeBoxName = 'memeBox';

  // Hive keys
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String userKey = 'user';
  static const String memeKey = 'meme';
}

class HiveTypeIds {
  const HiveTypeIds._();

  static const int userTypeId = 0;
  static const int memeTypeId = 1;
}