import 'package:blog_app/app_logger.dart';
import 'package:blog_app/data/models/user/user_response_model.dart';
import 'package:blog_app/domain/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'user_state.dart';

@injectable
class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(UserInitial());

  void fetchUser() async {
    try {
      emit(UserLoading());
      final res = await _userRepository.getUser();
      emit(UserSuccess(res.user!));
    } catch (err) {
      emit(UserFailure(error: err.toString()));
      logger.i("User response:${err.toString()}");
    }
  }
}
