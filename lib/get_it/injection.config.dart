// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../core/dio_client.dart' as _i364;
import '../core/dio_module.dart' as _i681;
import '../core/refresh_token_interceptor.dart' as _i969;
import '../core/token_interceptor.dart' as _i992;
import '../data/datasource/remote_data_souce/blog_remote_data_source/blog_remote_data_source.dart'
    as _i95;
import '../data/datasource/local_data_source/auth/auth_local_data_source.dart'
    as _i205;
import '../data/datasource/local_data_source/token/token_local_data_source.dart'
    as _i778;
import '../data/datasource/remote_data_souce/auth_remote_datasource/auth_remote_data_source.dart'
    as _i34;
import '../data/datasource/remote_data_souce/user_remote_datasource/user_remote_data_source.dart'
    as _i525;
import '../data/repository/auth_repository_impl.dart' as _i461;
import '../data/repository/blog_repository_impl.dart' as _i931;
import '../data/repository/user_repository_impl.dart' as _i890;
import '../domain/repository/auth_repository.dart' as _i306;
import '../domain/repository/blog_repository.dart' as _i24;
import '../domain/repository/user_repository.dart' as _i541;
import '../presentation/cubit/auth_cubit/auth_cubit.dart' as _i224;
import '../presentation/cubit/blog_cubit/blog_cubit.dart' as _i284;
import '../presentation/cubit/login_cubit/login_cubit.dart' as _i872;
import '../presentation/cubit/register_cubit/register_cubit.dart' as _i1039;
import '../presentation/cubit/user_cubit/user_cubit.dart' as _i807;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final dioModule = _$DioModule();
  gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
  gh.lazySingleton<_i361.Dio>(
    () => dioModule.refreshDio(),
    instanceName: 'refreshDio',
  );
  gh.lazySingleton<_i778.TokenLocalDataSource>(
    () => _i778.TokenLocalDataSourceImpl(),
  );
  gh.lazySingleton<_i205.AuthLocalDataSource>(
    () => _i205.AuthLocalDataSourceImpl(),
  );
  gh.factory<_i992.TokenInterceptor>(
    () => _i992.TokenInterceptor(
      gh<_i361.Dio>(),
      gh<_i361.Dio>(instanceName: 'refreshDio'),
      gh<_i778.TokenLocalDataSource>(),
      gh<_i205.AuthLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i364.DioClient>(
    () => _i364.DioClient(gh<_i992.TokenInterceptor>()),
  );
  gh.factory<_i969.RefreshTokenInterceptor>(
    () => _i969.RefreshTokenInterceptor(
      gh<_i778.TokenLocalDataSource>(),
      gh<_i205.AuthLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i525.UserRemoteDataSource>(
    () => _i525.UserRemoteDataSourceImpl(gh<_i364.DioClient>()),
  );
  gh.lazySingleton<_i34.AuthRemoteDataSource>(
    () => _i34.AuthRemoteDataSourceImpl(gh<_i364.DioClient>()),
  );
  gh.lazySingleton<_i95.BlogRemoteDataSource>(
    () => _i95.BlogRemoteDataSourceImpl(gh<_i364.DioClient>()),
  );
  gh.lazySingleton<_i306.AuthRepository>(
    () => _i461.AuthRepositoryImpl(
      gh<_i34.AuthRemoteDataSource>(),
      gh<_i778.TokenLocalDataSource>(),
      gh<_i205.AuthLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i541.UserRepository>(
    () => _i890.UserRepositoryImpl(gh<_i525.UserRemoteDataSource>()),
  );
  gh.factory<_i807.UserCubit>(
    () => _i807.UserCubit(gh<_i541.UserRepository>()),
  );
  gh.factory<_i872.LoginCubit>(
    () => _i872.LoginCubit(gh<_i306.AuthRepository>()),
  );
  gh.factory<_i1039.RegisterCubit>(
    () => _i1039.RegisterCubit(gh<_i306.AuthRepository>()),
  );
  gh.lazySingleton<_i24.BlogRepository>(
    () => _i931.BlogRepositoryImpl(gh<_i95.BlogRemoteDataSource>()),
  );
  gh.lazySingleton<_i224.AuthCubit>(
    () => _i224.AuthCubit(gh<_i306.AuthRepository>()),
  );
  gh.factory<_i284.BlogCubit>(() => _i284.BlogCubit(gh<_i24.BlogRepository>()));
  return getIt;
}

class _$DioModule extends _i681.DioModule {}
