import 'package:blog_app/app_logger.dart';
import 'package:blog_app/data/models/user/user_response_model.dart';
import 'package:blog_app/domain/entities/signin_params.dart';
import 'package:blog_app/domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(RegisterInitial());

  void register({required SigninParams signinParams}) async {
    try {
      emit(RegisterLoading());
      final res = await _authRepository.register(signinParams.toJson());
      emit(RegisterSuccess(user: res.user!));
    } catch (err) {
      emit(RegisterFailure(error: err.toString()));
      logger.i("User response:${err.toString()}");
    }
  }
}
