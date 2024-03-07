import 'package:flutter/material.dart';
import 'package:story_app/api/api_service.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/model/user.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthRepository authRepository;

  AuthProvider(this.authRepository, this.apiService);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  String errorMessage = "";

  Future<bool> login(User user) async {
    isLoadingLogin = true;
    notifyListeners();
    final result = await apiService.userLogin(user);

    if (!result.error) {
      await authRepository.login(result.loginResult!);
    } else {
      errorMessage = result.message;
    }

    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogin = false;
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }

  Future<bool> register(User user) async {
    isLoadingRegister = true;
    notifyListeners();
    final result = await apiService.userRegister(user);
    bool? isRegister;

    if (!result.error) {
      isRegister = true;
      isLoadingRegister = false;
      notifyListeners();
      return isRegister;
    } else {
      errorMessage = result.message;
    }

    isLoadingRegister = false;
    notifyListeners();

    isRegister = false;
    return isRegister;
  }
}
