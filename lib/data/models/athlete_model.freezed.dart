// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'athlete_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AthleteModel _$AthleteModelFromJson(Map<String, dynamic> json) {
  return _AthleteModel.fromJson(json);
}

/// @nodoc
mixin _$AthleteModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_medium')
  String? get profileMedium => throw _privateConstructorUsedError;
  String? get profile => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'sex')
  String? get sex => throw _privateConstructorUsedError;
  @JsonKey(name: 'premium')
  bool? get premium => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_heartrate')
  double? get maxHeartrate => throw _privateConstructorUsedError;
  @JsonKey(name: 'ftp')
  int? get ftp => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight')
  double? get weight => throw _privateConstructorUsedError;

  /// Serializes this AthleteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AthleteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AthleteModelCopyWith<AthleteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AthleteModelCopyWith<$Res> {
  factory $AthleteModelCopyWith(
    AthleteModel value,
    $Res Function(AthleteModel) then,
  ) = _$AthleteModelCopyWithImpl<$Res, AthleteModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'profile_medium') String? profileMedium,
    String? profile,
    String? city,
    String? state,
    String? country,
    @JsonKey(name: 'sex') String? sex,
    @JsonKey(name: 'premium') bool? premium,
    @JsonKey(name: 'max_heartrate') double? maxHeartrate,
    @JsonKey(name: 'ftp') int? ftp,
    @JsonKey(name: 'weight') double? weight,
  });
}

/// @nodoc
class _$AthleteModelCopyWithImpl<$Res, $Val extends AthleteModel>
    implements $AthleteModelCopyWith<$Res> {
  _$AthleteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AthleteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? profileMedium = freezed,
    Object? profile = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? country = freezed,
    Object? sex = freezed,
    Object? premium = freezed,
    Object? maxHeartrate = freezed,
    Object? ftp = freezed,
    Object? weight = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            profileMedium: freezed == profileMedium
                ? _value.profileMedium
                : profileMedium // ignore: cast_nullable_to_non_nullable
                      as String?,
            profile: freezed == profile
                ? _value.profile
                : profile // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            state: freezed == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String?,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
            sex: freezed == sex
                ? _value.sex
                : sex // ignore: cast_nullable_to_non_nullable
                      as String?,
            premium: freezed == premium
                ? _value.premium
                : premium // ignore: cast_nullable_to_non_nullable
                      as bool?,
            maxHeartrate: freezed == maxHeartrate
                ? _value.maxHeartrate
                : maxHeartrate // ignore: cast_nullable_to_non_nullable
                      as double?,
            ftp: freezed == ftp
                ? _value.ftp
                : ftp // ignore: cast_nullable_to_non_nullable
                      as int?,
            weight: freezed == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AthleteModelImplCopyWith<$Res>
    implements $AthleteModelCopyWith<$Res> {
  factory _$$AthleteModelImplCopyWith(
    _$AthleteModelImpl value,
    $Res Function(_$AthleteModelImpl) then,
  ) = __$$AthleteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'profile_medium') String? profileMedium,
    String? profile,
    String? city,
    String? state,
    String? country,
    @JsonKey(name: 'sex') String? sex,
    @JsonKey(name: 'premium') bool? premium,
    @JsonKey(name: 'max_heartrate') double? maxHeartrate,
    @JsonKey(name: 'ftp') int? ftp,
    @JsonKey(name: 'weight') double? weight,
  });
}

/// @nodoc
class __$$AthleteModelImplCopyWithImpl<$Res>
    extends _$AthleteModelCopyWithImpl<$Res, _$AthleteModelImpl>
    implements _$$AthleteModelImplCopyWith<$Res> {
  __$$AthleteModelImplCopyWithImpl(
    _$AthleteModelImpl _value,
    $Res Function(_$AthleteModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AthleteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? profileMedium = freezed,
    Object? profile = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? country = freezed,
    Object? sex = freezed,
    Object? premium = freezed,
    Object? maxHeartrate = freezed,
    Object? ftp = freezed,
    Object? weight = freezed,
  }) {
    return _then(
      _$AthleteModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileMedium: freezed == profileMedium
            ? _value.profileMedium
            : profileMedium // ignore: cast_nullable_to_non_nullable
                  as String?,
        profile: freezed == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        state: freezed == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String?,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
        sex: freezed == sex
            ? _value.sex
            : sex // ignore: cast_nullable_to_non_nullable
                  as String?,
        premium: freezed == premium
            ? _value.premium
            : premium // ignore: cast_nullable_to_non_nullable
                  as bool?,
        maxHeartrate: freezed == maxHeartrate
            ? _value.maxHeartrate
            : maxHeartrate // ignore: cast_nullable_to_non_nullable
                  as double?,
        ftp: freezed == ftp
            ? _value.ftp
            : ftp // ignore: cast_nullable_to_non_nullable
                  as int?,
        weight: freezed == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AthleteModelImpl extends _AthleteModel {
  const _$AthleteModelImpl({
    required this.id,
    @JsonKey(name: 'first_name') this.firstName,
    @JsonKey(name: 'last_name') this.lastName,
    @JsonKey(name: 'profile_medium') this.profileMedium,
    this.profile,
    this.city,
    this.state,
    this.country,
    @JsonKey(name: 'sex') this.sex,
    @JsonKey(name: 'premium') this.premium,
    @JsonKey(name: 'max_heartrate') this.maxHeartrate,
    @JsonKey(name: 'ftp') this.ftp,
    @JsonKey(name: 'weight') this.weight,
  }) : super._();

  factory _$AthleteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AthleteModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  @JsonKey(name: 'profile_medium')
  final String? profileMedium;
  @override
  final String? profile;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? country;
  @override
  @JsonKey(name: 'sex')
  final String? sex;
  @override
  @JsonKey(name: 'premium')
  final bool? premium;
  @override
  @JsonKey(name: 'max_heartrate')
  final double? maxHeartrate;
  @override
  @JsonKey(name: 'ftp')
  final int? ftp;
  @override
  @JsonKey(name: 'weight')
  final double? weight;

  @override
  String toString() {
    return 'AthleteModel(id: $id, firstName: $firstName, lastName: $lastName, profileMedium: $profileMedium, profile: $profile, city: $city, state: $state, country: $country, sex: $sex, premium: $premium, maxHeartrate: $maxHeartrate, ftp: $ftp, weight: $weight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AthleteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.profileMedium, profileMedium) ||
                other.profileMedium == profileMedium) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.premium, premium) || other.premium == premium) &&
            (identical(other.maxHeartrate, maxHeartrate) ||
                other.maxHeartrate == maxHeartrate) &&
            (identical(other.ftp, ftp) || other.ftp == ftp) &&
            (identical(other.weight, weight) || other.weight == weight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    firstName,
    lastName,
    profileMedium,
    profile,
    city,
    state,
    country,
    sex,
    premium,
    maxHeartrate,
    ftp,
    weight,
  );

  /// Create a copy of AthleteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AthleteModelImplCopyWith<_$AthleteModelImpl> get copyWith =>
      __$$AthleteModelImplCopyWithImpl<_$AthleteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AthleteModelImplToJson(this);
  }
}

abstract class _AthleteModel extends AthleteModel {
  const factory _AthleteModel({
    required final int id,
    @JsonKey(name: 'first_name') final String? firstName,
    @JsonKey(name: 'last_name') final String? lastName,
    @JsonKey(name: 'profile_medium') final String? profileMedium,
    final String? profile,
    final String? city,
    final String? state,
    final String? country,
    @JsonKey(name: 'sex') final String? sex,
    @JsonKey(name: 'premium') final bool? premium,
    @JsonKey(name: 'max_heartrate') final double? maxHeartrate,
    @JsonKey(name: 'ftp') final int? ftp,
    @JsonKey(name: 'weight') final double? weight,
  }) = _$AthleteModelImpl;
  const _AthleteModel._() : super._();

  factory _AthleteModel.fromJson(Map<String, dynamic> json) =
      _$AthleteModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  @JsonKey(name: 'profile_medium')
  String? get profileMedium;
  @override
  String? get profile;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get country;
  @override
  @JsonKey(name: 'sex')
  String? get sex;
  @override
  @JsonKey(name: 'premium')
  bool? get premium;
  @override
  @JsonKey(name: 'max_heartrate')
  double? get maxHeartrate;
  @override
  @JsonKey(name: 'ftp')
  int? get ftp;
  @override
  @JsonKey(name: 'weight')
  double? get weight;

  /// Create a copy of AthleteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AthleteModelImplCopyWith<_$AthleteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
