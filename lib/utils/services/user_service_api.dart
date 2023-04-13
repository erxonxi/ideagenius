import 'dart:convert';

import 'package:http/http.dart';

import '../../models/user.dart';
import '../../utils/services/user_service.dart';

class UserServiceApi implements UserService {
  final Client _client = Client();

  @override
  Future<User> login(String email, String password) {
    return _client.post(
      Uri.parse("https://shop-api.rubenruizpedreira.es/v1/users/session"),
      body: {
        "email": email,
        "password": password,
      },
    ).then((value) {
      if (value.statusCode == 201) {
        final responseBody = jsonDecode(value.body);

        return User.fromJson({
          "id": responseBody["session"]["user"]["id"],
          "email": responseBody["session"]["user"]["email"],
          "token": responseBody["token"],
        });
      } else {
        throw Exception("Error");
      }
    }).catchError((error) {
      throw Exception("Invalid credentials");
    });
  }

  @override
  Future<User> register(String email, String password) {
    throw UnimplementedError();
  }
}
