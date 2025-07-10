import 'package:blog_app/app.dart';
import 'package:blog_app/data/models/user/user_response_model.dart';
import 'package:blog_app/get_it/injection.dart';
import 'package:blog_app/presentation/cubit/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  configureDependencies();
  Bloc.observer = MyBlocObserver();
  runApp(const BlogApp());
}
