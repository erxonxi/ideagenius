import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserInitial()) {
    on<UserEvent>((event, emit) {
      if (event is UserLogin) {
        emit(UserLogged(User(email: event.email, token: "", id: '1')));
      } else if (event is UserLoggout) {
        emit(const UserInitial());
      }
    });
  }
}
