import 'package:blog_app/data/models/user/user_response_model.dart';
import 'package:blog_app/domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@LazySingleton()
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  void checkAuth() async {
    emit(AuthLoading());
    final res = await _repository.getUser();
    if (isClosed) return;
    try {
      if (res == null) {
        emit(Unauthenticated());
      } else {
        emit(Authenticated(res));
      }
    } catch (ex) {
      emit(AuthError(ex.toString()));
    }
  }

  void updateAuth(User user) async {
    emit(Authenticated(user));
  }

  void logout() async {
    emit(AuthLoading());
    await _repository.logout();
    emit(Unauthenticated());
  }
}
