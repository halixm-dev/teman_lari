// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'athlete_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AthleteModel {

 int get id;@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName;@JsonKey(name: 'profile_medium') String? get profileMedium; String? get profile; String? get city; String? get state; String? get country;@JsonKey(name: 'sex') String? get sex;@JsonKey(name: 'premium') bool? get premium;@JsonKey(name: 'max_heartrate') double? get maxHeartrate;@JsonKey(name: 'ftp') int? get ftp;@JsonKey(name: 'weight') double? get weight;
/// Create a copy of AthleteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AthleteModelCopyWith<AthleteModel> get copyWith => _$AthleteModelCopyWithImpl<AthleteModel>(this as AthleteModel, _$identity);

  /// Serializes this AthleteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AthleteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.profileMedium, profileMedium) || other.profileMedium == profileMedium)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.premium, premium) || other.premium == premium)&&(identical(other.maxHeartrate, maxHeartrate) || other.maxHeartrate == maxHeartrate)&&(identical(other.ftp, ftp) || other.ftp == ftp)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,profileMedium,profile,city,state,country,sex,premium,maxHeartrate,ftp,weight);

@override
String toString() {
  return 'AthleteModel(id: $id, firstName: $firstName, lastName: $lastName, profileMedium: $profileMedium, profile: $profile, city: $city, state: $state, country: $country, sex: $sex, premium: $premium, maxHeartrate: $maxHeartrate, ftp: $ftp, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $AthleteModelCopyWith<$Res>  {
  factory $AthleteModelCopyWith(AthleteModel value, $Res Function(AthleteModel) _then) = _$AthleteModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName,@JsonKey(name: 'profile_medium') String? profileMedium, String? profile, String? city, String? state, String? country,@JsonKey(name: 'sex') String? sex,@JsonKey(name: 'premium') bool? premium,@JsonKey(name: 'max_heartrate') double? maxHeartrate,@JsonKey(name: 'ftp') int? ftp,@JsonKey(name: 'weight') double? weight
});




}
/// @nodoc
class _$AthleteModelCopyWithImpl<$Res>
    implements $AthleteModelCopyWith<$Res> {
  _$AthleteModelCopyWithImpl(this._self, this._then);

  final AthleteModel _self;
  final $Res Function(AthleteModel) _then;

/// Create a copy of AthleteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,Object? profileMedium = freezed,Object? profile = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,Object? sex = freezed,Object? premium = freezed,Object? maxHeartrate = freezed,Object? ftp = freezed,Object? weight = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,profileMedium: freezed == profileMedium ? _self.profileMedium : profileMedium // ignore: cast_nullable_to_non_nullable
as String?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String?,premium: freezed == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as bool?,maxHeartrate: freezed == maxHeartrate ? _self.maxHeartrate : maxHeartrate // ignore: cast_nullable_to_non_nullable
as double?,ftp: freezed == ftp ? _self.ftp : ftp // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AthleteModel].
extension AthleteModelPatterns on AthleteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AthleteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AthleteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AthleteModel value)  $default,){
final _that = this;
switch (_that) {
case _AthleteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AthleteModel value)?  $default,){
final _that = this;
switch (_that) {
case _AthleteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName, @JsonKey(name: 'profile_medium')  String? profileMedium,  String? profile,  String? city,  String? state,  String? country, @JsonKey(name: 'sex')  String? sex, @JsonKey(name: 'premium')  bool? premium, @JsonKey(name: 'max_heartrate')  double? maxHeartrate, @JsonKey(name: 'ftp')  int? ftp, @JsonKey(name: 'weight')  double? weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AthleteModel() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.profileMedium,_that.profile,_that.city,_that.state,_that.country,_that.sex,_that.premium,_that.maxHeartrate,_that.ftp,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName, @JsonKey(name: 'profile_medium')  String? profileMedium,  String? profile,  String? city,  String? state,  String? country, @JsonKey(name: 'sex')  String? sex, @JsonKey(name: 'premium')  bool? premium, @JsonKey(name: 'max_heartrate')  double? maxHeartrate, @JsonKey(name: 'ftp')  int? ftp, @JsonKey(name: 'weight')  double? weight)  $default,) {final _that = this;
switch (_that) {
case _AthleteModel():
return $default(_that.id,_that.firstName,_that.lastName,_that.profileMedium,_that.profile,_that.city,_that.state,_that.country,_that.sex,_that.premium,_that.maxHeartrate,_that.ftp,_that.weight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName, @JsonKey(name: 'profile_medium')  String? profileMedium,  String? profile,  String? city,  String? state,  String? country, @JsonKey(name: 'sex')  String? sex, @JsonKey(name: 'premium')  bool? premium, @JsonKey(name: 'max_heartrate')  double? maxHeartrate, @JsonKey(name: 'ftp')  int? ftp, @JsonKey(name: 'weight')  double? weight)?  $default,) {final _that = this;
switch (_that) {
case _AthleteModel() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.profileMedium,_that.profile,_that.city,_that.state,_that.country,_that.sex,_that.premium,_that.maxHeartrate,_that.ftp,_that.weight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AthleteModel extends AthleteModel {
  const _AthleteModel({required this.id, @JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'last_name') this.lastName, @JsonKey(name: 'profile_medium') this.profileMedium, this.profile, this.city, this.state, this.country, @JsonKey(name: 'sex') this.sex, @JsonKey(name: 'premium') this.premium, @JsonKey(name: 'max_heartrate') this.maxHeartrate, @JsonKey(name: 'ftp') this.ftp, @JsonKey(name: 'weight') this.weight}): super._();
  factory _AthleteModel.fromJson(Map<String, dynamic> json) => _$AthleteModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override@JsonKey(name: 'profile_medium') final  String? profileMedium;
@override final  String? profile;
@override final  String? city;
@override final  String? state;
@override final  String? country;
@override@JsonKey(name: 'sex') final  String? sex;
@override@JsonKey(name: 'premium') final  bool? premium;
@override@JsonKey(name: 'max_heartrate') final  double? maxHeartrate;
@override@JsonKey(name: 'ftp') final  int? ftp;
@override@JsonKey(name: 'weight') final  double? weight;

/// Create a copy of AthleteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AthleteModelCopyWith<_AthleteModel> get copyWith => __$AthleteModelCopyWithImpl<_AthleteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AthleteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AthleteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.profileMedium, profileMedium) || other.profileMedium == profileMedium)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.premium, premium) || other.premium == premium)&&(identical(other.maxHeartrate, maxHeartrate) || other.maxHeartrate == maxHeartrate)&&(identical(other.ftp, ftp) || other.ftp == ftp)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,profileMedium,profile,city,state,country,sex,premium,maxHeartrate,ftp,weight);

@override
String toString() {
  return 'AthleteModel(id: $id, firstName: $firstName, lastName: $lastName, profileMedium: $profileMedium, profile: $profile, city: $city, state: $state, country: $country, sex: $sex, premium: $premium, maxHeartrate: $maxHeartrate, ftp: $ftp, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$AthleteModelCopyWith<$Res> implements $AthleteModelCopyWith<$Res> {
  factory _$AthleteModelCopyWith(_AthleteModel value, $Res Function(_AthleteModel) _then) = __$AthleteModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName,@JsonKey(name: 'profile_medium') String? profileMedium, String? profile, String? city, String? state, String? country,@JsonKey(name: 'sex') String? sex,@JsonKey(name: 'premium') bool? premium,@JsonKey(name: 'max_heartrate') double? maxHeartrate,@JsonKey(name: 'ftp') int? ftp,@JsonKey(name: 'weight') double? weight
});




}
/// @nodoc
class __$AthleteModelCopyWithImpl<$Res>
    implements _$AthleteModelCopyWith<$Res> {
  __$AthleteModelCopyWithImpl(this._self, this._then);

  final _AthleteModel _self;
  final $Res Function(_AthleteModel) _then;

/// Create a copy of AthleteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,Object? profileMedium = freezed,Object? profile = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,Object? sex = freezed,Object? premium = freezed,Object? maxHeartrate = freezed,Object? ftp = freezed,Object? weight = freezed,}) {
  return _then(_AthleteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,profileMedium: freezed == profileMedium ? _self.profileMedium : profileMedium // ignore: cast_nullable_to_non_nullable
as String?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String?,premium: freezed == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as bool?,maxHeartrate: freezed == maxHeartrate ? _self.maxHeartrate : maxHeartrate // ignore: cast_nullable_to_non_nullable
as double?,ftp: freezed == ftp ? _self.ftp : ftp // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
