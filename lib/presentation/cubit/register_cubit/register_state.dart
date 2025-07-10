part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterLoading extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterSuccess extends RegisterState {
  final User user;
  const RegisterSuccess({required this.user});
  @override
  List<Object> get props => [user];
}

class RegisterFailure extends RegisterState {
  final String error;
  const RegisterFailure({required this.error});
  @override
  List<Object> get props => [error];
}
