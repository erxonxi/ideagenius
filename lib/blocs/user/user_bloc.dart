import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/user.dart';
import '../../utils/services/user_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userServiceApi;

  UserBloc(
    this._userServiceApi,
  ) : super(const UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is UserLogin) {
        try {
          User user = await _userServiceApi.login(event.email, event.password);
          emit(UserLogged(user));
        } catch (e) {
          emit(UserError(e.toString()));
        }
      } else if (event is UserLoggout) {
        emit(const UserInitial());
      }
    });
  }
}
