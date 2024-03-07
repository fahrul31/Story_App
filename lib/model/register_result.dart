import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_result.g.dart';
part 'register_result.freezed.dart';

@freezed
class DefaultResult with _$DefaultResult {
  const factory DefaultResult({
    required bool error,
    required String message,
  }) = _DefaultResult;

  factory DefaultResult.fromJson(Map<String, dynamic> json) =>
      _$DefaultResultFromJson(json);
}
