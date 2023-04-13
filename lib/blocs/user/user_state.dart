part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  final User? user;

  const UserState(this.user);

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {
  const UserInitial() : super(null);
}

class UserLogged extends UserState {
  const UserLogged(User user) : super(user);
}

class UserError extends UserState {
  final String message;

  const UserError(this.message) : super(null);
}
