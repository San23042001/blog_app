import 'package:blog_app/data/models/user/user_response_model.dart';
import 'package:blog_app/domain/entities/login_params.dart';
import 'package:blog_app/domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  void login({required LoginParams loginParams}) async {
    try {
      emit(LoginLoading());
      final res = await _authRepository.login(loginParams.toJson());
      emit(LoginSuccess(user: res.user!));
    } catch (err) {
      emit(LoginFailure(error: err.toString()));
    }
  }
}
