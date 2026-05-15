// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) {
  return _ActivityModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  @JsonKey(name: 'moving_time')
  int get movingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'elapsed_time')
  int get elapsedTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_elevation_gain')
  double get totalElevationGain => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  String get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_speed')
  double get averageSpeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_speed')
  double get maxSpeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_heartrate')
  double? get averageHeartrate => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_heartrate')
  double? get maxHeartrate => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_cadence')
  double? get averageCadence => throw _privateConstructorUsedError;
  @JsonKey(name: 'suffer_score')
  int? get sufferScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_heartrate')
  bool get hasHeartrate => throw _privateConstructorUsedError;
  @JsonKey(name: 'workout_type')
  int? get workoutType => throw _privateConstructorUsedError;
  @JsonKey(name: 'perceived_exertion')
  double? get perceivedExertion => throw _privateConstructorUsedError;

  /// Serializes this ActivityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityModelCopyWith<ActivityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityModelCopyWith<$Res> {
  factory $ActivityModelCopyWith(
    ActivityModel value,
    $Res Function(ActivityModel) then,
  ) = _$ActivityModelCopyWithImpl<$Res, ActivityModel>;
  @useResult
  $Res call({
    int id,
    String name,
    String type,
    double distance,
    @JsonKey(name: 'moving_time') int movingTime,
    @JsonKey(name: 'elapsed_time') int elapsedTime,
    @JsonKey(name: 'total_elevation_gain') double totalElevationGain,
    @JsonKey(name: 'start_date') String startDate,
    @JsonKey(name: 'average_speed') double averageSpeed,
    @JsonKey(name: 'max_speed') double maxSpeed,
    @JsonKey(name: 'average_heartrate') double? averageHeartrate,
    @JsonKey(name: 'max_heartrate') double? maxHeartrate,
    @JsonKey(name: 'average_cadence') double? averageCadence,
    @JsonKey(name: 'suffer_score') int? sufferScore,
    @JsonKey(name: 'has_heartrate') bool hasHeartrate,
    @JsonKey(name: 'workout_type') int? workoutType,
    @JsonKey(name: 'perceived_exertion') double? perceivedExertion,
  });
}

/// @nodoc
class _$ActivityModelCopyWithImpl<$Res, $Val extends ActivityModel>
    implements $ActivityModelCopyWith<$Res> {
  _$ActivityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? distance = null,
    Object? movingTime = null,
    Object? elapsedTime = null,
    Object? totalElevationGain = null,
    Object? startDate = null,
    Object? averageSpeed = null,
    Object? maxSpeed = null,
    Object? averageHeartrate = freezed,
    Object? maxHeartrate = freezed,
    Object? averageCadence = freezed,
    Object? sufferScore = freezed,
    Object? hasHeartrate = null,
    Object? workoutType = freezed,
    Object? perceivedExertion = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            distance: null == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                      as double,
            movingTime: null == movingTime
                ? _value.movingTime
                : movingTime // ignore: cast_nullable_to_non_nullable
                      as int,
            elapsedTime: null == elapsedTime
                ? _value.elapsedTime
                : elapsedTime // ignore: cast_nullable_to_non_nullable
                      as int,
            totalElevationGain: null == totalElevationGain
                ? _value.totalElevationGain
                : totalElevationGain // ignore: cast_nullable_to_non_nullable
                      as double,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as String,
            averageSpeed: null == averageSpeed
                ? _value.averageSpeed
                : averageSpeed // ignore: cast_nullable_to_non_nullable
                      as double,
            maxSpeed: null == maxSpeed
                ? _value.maxSpeed
                : maxSpeed // ignore: cast_nullable_to_non_nullable
                      as double,
            averageHeartrate: freezed == averageHeartrate
                ? _value.averageHeartrate
                : averageHeartrate // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxHeartrate: freezed == maxHeartrate
                ? _value.maxHeartrate
                : maxHeartrate // ignore: cast_nullable_to_non_nullable
                      as double?,
            averageCadence: freezed == averageCadence
                ? _value.averageCadence
                : averageCadence // ignore: cast_nullable_to_non_nullable
                      as double?,
            sufferScore: freezed == sufferScore
                ? _value.sufferScore
                : sufferScore // ignore: cast_nullable_to_non_nullable
                      as int?,
            hasHeartrate: null == hasHeartrate
                ? _value.hasHeartrate
                : hasHeartrate // ignore: cast_nullable_to_non_nullable
                      as bool,
            workoutType: freezed == workoutType
                ? _value.workoutType
                : workoutType // ignore: cast_nullable_to_non_nullable
                      as int?,
            perceivedExertion: freezed == perceivedExertion
                ? _value.perceivedExertion
                : perceivedExertion // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityModelImplCopyWith<$Res>
    implements $ActivityModelCopyWith<$Res> {
  factory _$$ActivityModelImplCopyWith(
    _$ActivityModelImpl value,
    $Res Function(_$ActivityModelImpl) then,
  ) = __$$ActivityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String type,
    double distance,
    @JsonKey(name: 'moving_time') int movingTime,
    @JsonKey(name: 'elapsed_time') int elapsedTime,
    @JsonKey(name: 'total_elevation_gain') double totalElevationGain,
    @JsonKey(name: 'start_date') String startDate,
    @JsonKey(name: 'average_speed') double averageSpeed,
    @JsonKey(name: 'max_speed') double maxSpeed,
    @JsonKey(name: 'average_heartrate') double? averageHeartrate,
    @JsonKey(name: 'max_heartrate') double? maxHeartrate,
    @JsonKey(name: 'average_cadence') double? averageCadence,
    @JsonKey(name: 'suffer_score') int? sufferScore,
    @JsonKey(name: 'has_heartrate') bool hasHeartrate,
    @JsonKey(name: 'workout_type') int? workoutType,
    @JsonKey(name: 'perceived_exertion') double? perceivedExertion,
  });
}

/// @nodoc
class __$$ActivityModelImplCopyWithImpl<$Res>
    extends _$ActivityModelCopyWithImpl<$Res, _$ActivityModelImpl>
    implements _$$ActivityModelImplCopyWith<$Res> {
  __$$ActivityModelImplCopyWithImpl(
    _$ActivityModelImpl _value,
    $Res Function(_$ActivityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? distance = null,
    Object? movingTime = null,
    Object? elapsedTime = null,
    Object? totalElevationGain = null,
    Object? startDate = null,
    Object? averageSpeed = null,
    Object? maxSpeed = null,
    Object? averageHeartrate = freezed,
    Object? maxHeartrate = freezed,
    Object? averageCadence = freezed,
    Object? sufferScore = freezed,
    Object? hasHeartrate = null,
    Object? workoutType = freezed,
    Object? perceivedExertion = freezed,
  }) {
    return _then(
      _$ActivityModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        distance: null == distance
            ? _value.distance
            : distance // ignore: cast_nullable_to_non_nullable
                  as double,
        movingTime: null == movingTime
            ? _value.movingTime
            : movingTime // ignore: cast_nullable_to_non_nullable
                  as int,
        elapsedTime: null == elapsedTime
            ? _value.elapsedTime
            : elapsedTime // ignore: cast_nullable_to_non_nullable
                  as int,
        totalElevationGain: null == totalElevationGain
            ? _value.totalElevationGain
            : totalElevationGain // ignore: cast_nullable_to_non_nullable
                  as double,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as String,
        averageSpeed: null == averageSpeed
            ? _value.averageSpeed
            : averageSpeed // ignore: cast_nullable_to_non_nullable
                  as double,
        maxSpeed: null == maxSpeed
            ? _value.maxSpeed
            : maxSpeed // ignore: cast_nullable_to_non_nullable
                  as double,
        averageHeartrate: freezed == averageHeartrate
            ? _value.averageHeartrate
            : averageHeartrate // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxHeartrate: freezed == maxHeartrate
            ? _value.maxHeartrate
            : maxHeartrate // ignore: cast_nullable_to_non_nullable
                  as double?,
        averageCadence: freezed == averageCadence
            ? _value.averageCadence
            : averageCadence // ignore: cast_nullable_to_non_nullable
                  as double?,
        sufferScore: freezed == sufferScore
            ? _value.sufferScore
            : sufferScore // ignore: cast_nullable_to_non_nullable
                  as int?,
        hasHeartrate: null == hasHeartrate
            ? _value.hasHeartrate
            : hasHeartrate // ignore: cast_nullable_to_non_nullable
                  as bool,
        workoutType: freezed == workoutType
            ? _value.workoutType
            : workoutType // ignore: cast_nullable_to_non_nullable
                  as int?,
        perceivedExertion: freezed == perceivedExertion
            ? _value.perceivedExertion
            : perceivedExertion // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityModelImpl extends _ActivityModel {
  const _$ActivityModelImpl({
    required this.id,
    required this.name,
    required this.type,
    required this.distance,
    @JsonKey(name: 'moving_time') required this.movingTime,
    @JsonKey(name: 'elapsed_time') required this.elapsedTime,
    @JsonKey(name: 'total_elevation_gain') required this.totalElevationGain,
    @JsonKey(name: 'start_date') required this.startDate,
    @JsonKey(name: 'average_speed') required this.averageSpeed,
    @JsonKey(name: 'max_speed') required this.maxSpeed,
    @JsonKey(name: 'average_heartrate') this.averageHeartrate,
    @JsonKey(name: 'max_heartrate') this.maxHeartrate,
    @JsonKey(name: 'average_cadence') this.averageCadence,
    @JsonKey(name: 'suffer_score') this.sufferScore,
    @JsonKey(name: 'has_heartrate') this.hasHeartrate = false,
    @JsonKey(name: 'workout_type') this.workoutType,
    @JsonKey(name: 'perceived_exertion') this.perceivedExertion,
  }) : super._();

  factory _$ActivityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String type;
  @override
  final double distance;
  @override
  @JsonKey(name: 'moving_time')
  final int movingTime;
  @override
  @JsonKey(name: 'elapsed_time')
  final int elapsedTime;
  @override
  @JsonKey(name: 'total_elevation_gain')
  final double totalElevationGain;
  @override
  @JsonKey(name: 'start_date')
  final String startDate;
  @override
  @JsonKey(name: 'average_speed')
  final double averageSpeed;
  @override
  @JsonKey(name: 'max_speed')
  final double maxSpeed;
  @override
  @JsonKey(name: 'average_heartrate')
  final double? averageHeartrate;
  @override
  @JsonKey(name: 'max_heartrate')
  final double? maxHeartrate;
  @override
  @JsonKey(name: 'average_cadence')
  final double? averageCadence;
  @override
  @JsonKey(name: 'suffer_score')
  final int? sufferScore;
  @override
  @JsonKey(name: 'has_heartrate')
  final bool hasHeartrate;
  @override
  @JsonKey(name: 'workout_type')
  final int? workoutType;
  @override
  @JsonKey(name: 'perceived_exertion')
  final double? perceivedExertion;

  @override
  String toString() {
    return 'ActivityModel(id: $id, name: $name, type: $type, distance: $distance, movingTime: $movingTime, elapsedTime: $elapsedTime, totalElevationGain: $totalElevationGain, startDate: $startDate, averageSpeed: $averageSpeed, maxSpeed: $maxSpeed, averageHeartrate: $averageHeartrate, maxHeartrate: $maxHeartrate, averageCadence: $averageCadence, sufferScore: $sufferScore, hasHeartrate: $hasHeartrate, workoutType: $workoutType, perceivedExertion: $perceivedExertion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.movingTime, movingTime) ||
                other.movingTime == movingTime) &&
            (identical(other.elapsedTime, elapsedTime) ||
                other.elapsedTime == elapsedTime) &&
            (identical(other.totalElevationGain, totalElevationGain) ||
                other.totalElevationGain == totalElevationGain) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.averageSpeed, averageSpeed) ||
                other.averageSpeed == averageSpeed) &&
            (identical(other.maxSpeed, maxSpeed) ||
                other.maxSpeed == maxSpeed) &&
            (identical(other.averageHeartrate, averageHeartrate) ||
                other.averageHeartrate == averageHeartrate) &&
            (identical(other.maxHeartrate, maxHeartrate) ||
                other.maxHeartrate == maxHeartrate) &&
            (identical(other.averageCadence, averageCadence) ||
                other.averageCadence == averageCadence) &&
            (identical(other.sufferScore, sufferScore) ||
                other.sufferScore == sufferScore) &&
            (identical(other.hasHeartrate, hasHeartrate) ||
                other.hasHeartrate == hasHeartrate) &&
            (identical(other.workoutType, workoutType) ||
                other.workoutType == workoutType) &&
            (identical(other.perceivedExertion, perceivedExertion) ||
                other.perceivedExertion == perceivedExertion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    distance,
    movingTime,
    elapsedTime,
    totalElevationGain,
    startDate,
    averageSpeed,
    maxSpeed,
    averageHeartrate,
    maxHeartrate,
    averageCadence,
    sufferScore,
    hasHeartrate,
    workoutType,
    perceivedExertion,
  );

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityModelImplCopyWith<_$ActivityModelImpl> get copyWith =>
      __$$ActivityModelImplCopyWithImpl<_$ActivityModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityModelImplToJson(this);
  }
}

abstract class _ActivityModel extends ActivityModel {
  const factory _ActivityModel({
    required final int id,
    required final String name,
    required final String type,
    required final double distance,
    @JsonKey(name: 'moving_time') required final int movingTime,
    @JsonKey(name: 'elapsed_time') required final int elapsedTime,
    @JsonKey(name: 'total_elevation_gain')
    required final double totalElevationGain,
    @JsonKey(name: 'start_date') required final String startDate,
    @JsonKey(name: 'average_speed') required final double averageSpeed,
    @JsonKey(name: 'max_speed') required final double maxSpeed,
    @JsonKey(name: 'average_heartrate') final double? averageHeartrate,
    @JsonKey(name: 'max_heartrate') final double? maxHeartrate,
    @JsonKey(name: 'average_cadence') final double? averageCadence,
    @JsonKey(name: 'suffer_score') final int? sufferScore,
    @JsonKey(name: 'has_heartrate') final bool hasHeartrate,
    @JsonKey(name: 'workout_type') final int? workoutType,
    @JsonKey(name: 'perceived_exertion') final double? perceivedExertion,
  }) = _$ActivityModelImpl;
  const _ActivityModel._() : super._();

  factory _ActivityModel.fromJson(Map<String, dynamic> json) =
      _$ActivityModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get type;
  @override
  double get distance;
  @override
  @JsonKey(name: 'moving_time')
  int get movingTime;
  @override
  @JsonKey(name: 'elapsed_time')
  int get elapsedTime;
  @override
  @JsonKey(name: 'total_elevation_gain')
  double get totalElevationGain;
  @override
  @JsonKey(name: 'start_date')
  String get startDate;
  @override
  @JsonKey(name: 'average_speed')
  double get averageSpeed;
  @override
  @JsonKey(name: 'max_speed')
  double get maxSpeed;
  @override
  @JsonKey(name: 'average_heartrate')
  double? get averageHeartrate;
  @override
  @JsonKey(name: 'max_heartrate')
  double? get maxHeartrate;
  @override
  @JsonKey(name: 'average_cadence')
  double? get averageCadence;
  @override
  @JsonKey(name: 'suffer_score')
  int? get sufferScore;
  @override
  @JsonKey(name: 'has_heartrate')
  bool get hasHeartrate;
  @override
  @JsonKey(name: 'workout_type')
  int? get workoutType;
  @override
  @JsonKey(name: 'perceived_exertion')
  double? get perceivedExertion;

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityModelImplCopyWith<_$ActivityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
