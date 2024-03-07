import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/model/login_result.dart';

class AuthRepository {
  final String stateKey = "state";
  final String userKey = "user";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> login(LoginResult data) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(userKey, jsonEncode(data));
    return preferences.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove(userKey);
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, false);
  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, "");
  }

  Future<LoginResult?> getUser() async {
    late LoginResult? user;
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final json = preferences.getString(userKey) ?? "";
    try {
      user = LoginResult.fromJson(jsonDecode(json));
    } catch (e) {
      user = null;
    }
    return user;
  }
}
