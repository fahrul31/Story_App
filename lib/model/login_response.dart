import 'package:freezed_annotation/freezed_annotation.dart';

import 'login_result.dart';
part 'login_response.g.dart';
part 'login_response.freezed.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required bool error,
    required String message,
    required LoginResult? loginResult,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
