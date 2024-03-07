// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DefaultResult _$DefaultResultFromJson(Map<String, dynamic> json) {
  return _DefaultResult.fromJson(json);
}

/// @nodoc
mixin _$DefaultResult {
  bool get error => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DefaultResultCopyWith<DefaultResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefaultResultCopyWith<$Res> {
  factory $DefaultResultCopyWith(
          DefaultResult value, $Res Function(DefaultResult) then) =
      _$DefaultResultCopyWithImpl<$Res, DefaultResult>;
  @useResult
  $Res call({bool error, String message});
}

/// @nodoc
class _$DefaultResultCopyWithImpl<$Res, $Val extends DefaultResult>
    implements $DefaultResultCopyWith<$Res> {
  _$DefaultResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DefaultResultImplCopyWith<$Res>
    implements $DefaultResultCopyWith<$Res> {
  factory _$$DefaultResultImplCopyWith(
          _$DefaultResultImpl value, $Res Function(_$DefaultResultImpl) then) =
      __$$DefaultResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool error, String message});
}

/// @nodoc
class __$$DefaultResultImplCopyWithImpl<$Res>
    extends _$DefaultResultCopyWithImpl<$Res, _$DefaultResultImpl>
    implements _$$DefaultResultImplCopyWith<$Res> {
  __$$DefaultResultImplCopyWithImpl(
      _$DefaultResultImpl _value, $Res Function(_$DefaultResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
  }) {
    return _then(_$DefaultResultImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DefaultResultImpl implements _DefaultResult {
  const _$DefaultResultImpl({required this.error, required this.message});

  factory _$DefaultResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$DefaultResultImplFromJson(json);

  @override
  final bool error;
  @override
  final String message;

  @override
  String toString() {
    return 'DefaultResult(error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DefaultResultImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, error, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DefaultResultImplCopyWith<_$DefaultResultImpl> get copyWith =>
      __$$DefaultResultImplCopyWithImpl<_$DefaultResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DefaultResultImplToJson(
      this,
    );
  }
}

abstract class _DefaultResult implements DefaultResult {
  const factory _DefaultResult(
      {required final bool error,
      required final String message}) = _$DefaultResultImpl;

  factory _DefaultResult.fromJson(Map<String, dynamic> json) =
      _$DefaultResultImpl.fromJson;

  @override
  bool get error;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$DefaultResultImplCopyWith<_$DefaultResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
