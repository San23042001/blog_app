import 'package:blog_app/get_it/injection.dart';
import 'package:blog_app/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:blog_app/presentation/cubit/blog_cubit/blog_cubit.dart';
import 'package:blog_app/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:blog_app/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:blog_app/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:blog_app/presentation/screens/splash_screen.dart';
import 'package:blog_app/presentation/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()..checkAuth()),
        BlocProvider(create: (context) => getIt<RegisterCubit>()),
        BlocProvider(create: (context) => getIt<LoginCubit>()),
        BlocProvider(create: (context) => getIt<UserCubit>()),
        BlocProvider(create: (context) => getIt<BlogCubit>()),
      ],
      child: GlobalLoaderOverlay(
        overlayWidgetBuilder: (_) {
          return const CustomLoader();
        },
        child: MaterialApp(
          title: 'Blog App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Quicksand',
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(fontFamily: 'Quicksand', fontSize: 18),
            ),
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
