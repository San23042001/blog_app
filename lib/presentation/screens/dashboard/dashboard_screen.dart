import 'package:blog_app/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:blog_app/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:blog_app/presentation/screens/auth/register_screen.dart';
import 'package:blog_app/presentation/screens/dashboard/create_blog_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:page_transition/page_transition.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  childBuilder: (context) => CreateBlogScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                context.loaderOverlay.show();
              }
              if (state is Unauthenticated) {
                context.loaderOverlay.hide();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              }
              if (state is AuthError) {
                context.loaderOverlay.hide();
                Fluttertoast.showToast(
                  msg: state.error,
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.BOTTOM,
                  textColor: Colors.white,
                );
              }
            },
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
                icon: Icon(Icons.logout),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return Text("Loading user..");
              }
              if (state is UserSuccess) {
                return Text("Welcome ${state.user.username}");
              }
              if (state is UserFailure) {
                return Text(state.error);
              }
              return SizedBox();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              context.read<UserCubit>().fetchUser();
            },
            child: Text("Fetch User"),
          ),
        ],
      ),
    );
  }
}
