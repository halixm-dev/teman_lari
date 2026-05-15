// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'strava_tokens.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StravaTokens _$StravaTokensFromJson(Map<String, dynamic> json) {
  return _StravaTokens.fromJson(json);
}

/// @nodoc
mixin _$StravaTokens {
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  int get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this StravaTokens to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StravaTokens
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StravaTokensCopyWith<StravaTokens> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StravaTokensCopyWith<$Res> {
  factory $StravaTokensCopyWith(
    StravaTokens value,
    $Res Function(StravaTokens) then,
  ) = _$StravaTokensCopyWithImpl<$Res, StravaTokens>;
  @useResult
  $Res call({
    @JsonKey(name: 'access_token') String accessToken,
    @JsonKey(name: 'refresh_token') String refreshToken,
    @JsonKey(name: 'expires_at') int expiresAt,
  });
}

/// @nodoc
class _$StravaTokensCopyWithImpl<$Res, $Val extends StravaTokens>
    implements $StravaTokensCopyWith<$Res> {
  _$StravaTokensCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StravaTokens
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StravaTokensImplCopyWith<$Res>
    implements $StravaTokensCopyWith<$Res> {
  factory _$$StravaTokensImplCopyWith(
    _$StravaTokensImpl value,
    $Res Function(_$StravaTokensImpl) then,
  ) = __$$StravaTokensImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'access_token') String accessToken,
    @JsonKey(name: 'refresh_token') String refreshToken,
    @JsonKey(name: 'expires_at') int expiresAt,
  });
}

/// @nodoc
class __$$StravaTokensImplCopyWithImpl<$Res>
    extends _$StravaTokensCopyWithImpl<$Res, _$StravaTokensImpl>
    implements _$$StravaTokensImplCopyWith<$Res> {
  __$$StravaTokensImplCopyWithImpl(
    _$StravaTokensImpl _value,
    $Res Function(_$StravaTokensImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StravaTokens
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _$StravaTokensImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StravaTokensImpl extends _StravaTokens {
  const _$StravaTokensImpl({
    @JsonKey(name: 'access_token') required this.accessToken,
    @JsonKey(name: 'refresh_token') required this.refreshToken,
    @JsonKey(name: 'expires_at') required this.expiresAt,
  }) : super._();

  factory _$StravaTokensImpl.fromJson(Map<String, dynamic> json) =>
      _$$StravaTokensImplFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @override
  @JsonKey(name: 'expires_at')
  final int expiresAt;

  @override
  String toString() {
    return 'StravaTokens(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StravaTokensImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, expiresAt);

  /// Create a copy of StravaTokens
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StravaTokensImplCopyWith<_$StravaTokensImpl> get copyWith =>
      __$$StravaTokensImplCopyWithImpl<_$StravaTokensImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StravaTokensImplToJson(this);
  }
}

abstract class _StravaTokens extends StravaTokens {
  const factory _StravaTokens({
    @JsonKey(name: 'access_token') required final String accessToken,
    @JsonKey(name: 'refresh_token') required final String refreshToken,
    @JsonKey(name: 'expires_at') required final int expiresAt,
  }) = _$StravaTokensImpl;
  const _StravaTokens._() : super._();

  factory _StravaTokens.fromJson(Map<String, dynamic> json) =
      _$StravaTokensImpl.fromJson;

  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;
  @override
  @JsonKey(name: 'expires_at')
  int get expiresAt;

  /// Create a copy of StravaTokens
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StravaTokensImplCopyWith<_$StravaTokensImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
