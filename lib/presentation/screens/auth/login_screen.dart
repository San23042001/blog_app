import 'dart:ui';

import 'package:blog_app/domain/entities/login_params.dart';

import 'package:blog_app/gen/assets.gen.dart';

import 'package:blog_app/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:blog_app/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:blog_app/presentation/screens/auth/register_screen.dart';

import 'package:blog_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:blog_app/presentation/widgets/custom_button.dart';
import 'package:blog_app/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MyAssets.images.register.provider(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 10),
                  child: Container(
                    width: 320,
                    height: MediaQuery.of(context).size.height / 2,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextfield(
                            hintText: "Email",
                            icon: Icons.person,
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),
                          CustomTextfield(
                            hintText: "Password",
                            icon: Icons.lock,
                            obscureText: _obscureText,
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            showSuffixIcon: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }

                              // if (value.length < 8) {
                              //   return 'Password must be at least 8 characters long';
                              // }
                              // final passwordRegex = RegExp(
                              //   r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
                              // );

                              // if (!passwordRegex.hasMatch(value)) {
                              //   return 'Use 8+ characters with upper & lower case, number, and symbol.';
                              // }

                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          BlocConsumer<LoginCubit, LoginState>(
                            listener: (context, state) {
                              if (state is LoginLoading) {
                                context.loaderOverlay.show();
                              }
                              if (state is LoginSuccess) {
                                context.loaderOverlay.hide();
                                context.read<AuthCubit>().updateAuth(
                                  state.user,
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DashboardScreen(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              }
                              if (state is LoginFailure) {
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
                              return CustomButton(
                                text: "Login",
                                onPressed: state is LoginLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<LoginCubit>().login(
                                            loginParams: LoginParams(
                                              email: _emailController.text
                                                  .trim(),
                                              password: _passwordController.text
                                                  .trim(),
                                            ),
                                          );
                                        }
                                      },
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  childBuilder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Don't have an account? Register",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
