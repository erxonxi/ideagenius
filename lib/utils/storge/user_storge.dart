import '../../models/user.dart';

abstract class UserStorge {
  Future<void> saveUser(User user);
  Future<User> getUser();
  Future<void> deleteUser();
}
