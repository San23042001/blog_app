part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserSuccess extends UserState {
  final User user;
  const UserSuccess(this.user);
  @override
  List<Object> get props => [user];
}

class UserFailure extends UserState {
  final String error;
  const UserFailure({required this.error});
  @override
  List<Object> get props => [error];
}
