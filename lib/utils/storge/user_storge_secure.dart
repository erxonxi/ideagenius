import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/user.dart';
import '../../utils/storge/secure_storge.dart';
import '../../utils/storge/user_storge.dart';

class UserStorgeSecure extends SecureStorge implements UserStorge {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> deleteUser() {
    return _storage.delete(
      key: "user",
      iOptions: getIOSOptions(),
      aOptions: getAndroidOptions(),
    );
  }

  @override
  Future<User> getUser() {
    return _storage
        .read(
      key: "user",
      iOptions: getIOSOptions(),
      aOptions: getAndroidOptions(),
    )
        .then((value) {
      if (value == null) {
        return User(
          id: "",
          email: "",
          token: "",
        );
      }

      return User.fromJson(jsonDecode(value));
    });
  }

  @override
  Future<void> saveUser(User user) async {
    await _storage.write(
      key: "user",
      value: user.toJson().toString(),
      iOptions: getIOSOptions(),
      aOptions: getAndroidOptions(),
    );
  }
}
