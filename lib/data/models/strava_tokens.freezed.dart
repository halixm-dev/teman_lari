// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'strava_tokens.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StravaTokens {

@JsonKey(name: 'access_token') String get accessToken;@JsonKey(name: 'refresh_token') String get refreshToken;@JsonKey(name: 'expires_at') int get expiresAt;
/// Create a copy of StravaTokens
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StravaTokensCopyWith<StravaTokens> get copyWith => _$StravaTokensCopyWithImpl<StravaTokens>(this as StravaTokens, _$identity);

  /// Serializes this StravaTokens to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StravaTokens&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresAt);

@override
String toString() {
  return 'StravaTokens(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $StravaTokensCopyWith<$Res>  {
  factory $StravaTokensCopyWith(StravaTokens value, $Res Function(StravaTokens) _then) = _$StravaTokensCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken,@JsonKey(name: 'expires_at') int expiresAt
});




}
/// @nodoc
class _$StravaTokensCopyWithImpl<$Res>
    implements $StravaTokensCopyWith<$Res> {
  _$StravaTokensCopyWithImpl(this._self, this._then);

  final StravaTokens _self;
  final $Res Function(StravaTokens) _then;

/// Create a copy of StravaTokens
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StravaTokens].
extension StravaTokensPatterns on StravaTokens {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StravaTokens value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StravaTokens() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StravaTokens value)  $default,){
final _that = this;
switch (_that) {
case _StravaTokens():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StravaTokens value)?  $default,){
final _that = this;
switch (_that) {
case _StravaTokens() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'expires_at')  int expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StravaTokens() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'expires_at')  int expiresAt)  $default,) {final _that = this;
switch (_that) {
case _StravaTokens():
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'expires_at')  int expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _StravaTokens() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StravaTokens extends StravaTokens {
  const _StravaTokens({@JsonKey(name: 'access_token') required this.accessToken, @JsonKey(name: 'refresh_token') required this.refreshToken, @JsonKey(name: 'expires_at') required this.expiresAt}): super._();
  factory _StravaTokens.fromJson(Map<String, dynamic> json) => _$StravaTokensFromJson(json);

@override@JsonKey(name: 'access_token') final  String accessToken;
@override@JsonKey(name: 'refresh_token') final  String refreshToken;
@override@JsonKey(name: 'expires_at') final  int expiresAt;

/// Create a copy of StravaTokens
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StravaTokensCopyWith<_StravaTokens> get copyWith => __$StravaTokensCopyWithImpl<_StravaTokens>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StravaTokensToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StravaTokens&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresAt);

@override
String toString() {
  return 'StravaTokens(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$StravaTokensCopyWith<$Res> implements $StravaTokensCopyWith<$Res> {
  factory _$StravaTokensCopyWith(_StravaTokens value, $Res Function(_StravaTokens) _then) = __$StravaTokensCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken,@JsonKey(name: 'expires_at') int expiresAt
});




}
/// @nodoc
class __$StravaTokensCopyWithImpl<$Res>
    implements _$StravaTokensCopyWith<$Res> {
  __$StravaTokensCopyWithImpl(this._self, this._then);

  final _StravaTokens _self;
  final $Res Function(_StravaTokens) _then;

/// Create a copy of StravaTokens
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,}) {
  return _then(_StravaTokens(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
