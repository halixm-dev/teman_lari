// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_streams.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityStreams _$ActivityStreamsFromJson(Map<String, dynamic> json) {
  return _ActivityStreams.fromJson(json);
}

/// @nodoc
mixin _$ActivityStreams {
  StreamData? get time => throw _privateConstructorUsedError;
  @JsonKey(name: 'heartrate')
  StreamData? get heartrate => throw _privateConstructorUsedError;
  StreamData? get cadence => throw _privateConstructorUsedError;
  @JsonKey(name: 'velocity_smooth')
  StreamData? get velocitySmooth => throw _privateConstructorUsedError;
  StreamData? get altitude => throw _privateConstructorUsedError;

  /// Serializes this ActivityStreams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityStreams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityStreamsCopyWith<ActivityStreams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityStreamsCopyWith<$Res> {
  factory $ActivityStreamsCopyWith(
    ActivityStreams value,
    $Res Function(ActivityStreams) then,
  ) = _$ActivityStreamsCopyWithImpl<$Res, ActivityStreams>;
  @useResult
  $Res call({
    StreamData? time,
    @JsonKey(name: 'heartrate') StreamData? heartrate,
    StreamData? cadence,
    @JsonKey(name: 'velocity_smooth') StreamData? velocitySmooth,
    StreamData? altitude,
  });

  $StreamDataCopyWith<$Res>? get time;
  $StreamDataCopyWith<$Res>? get heartrate;
  $StreamDataCopyWith<$Res>? get cadence;
  $StreamDataCopyWith<$Res>? get velocitySmooth;
  $StreamDataCopyWith<$Res>? get altitude;
}

/// @nodoc
class _$ActivityStreamsCopyWithImpl<$Res, $Val extends ActivityStreams>
    implements $ActivityStreamsCopyWith<$Res> {
  _$ActivityStreamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityStreams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = freezed,
    Object? heartrate = freezed,
    Object? cadence = freezed,
    Object? velocitySmooth = freezed,
    Object? altitude = freezed,
  }) {
    return _then(
      _value.copyWith(
            time: freezed == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as StreamData?,
            heartrate: freezed == heartrate
                ? _value.heartrate
                : heartrate // ignore: cast_nullable_to_non_nullable
                      as StreamData?,
            cadence: freezed == cadence
                ? _value.cadence
                : cadence // ignore: cast_nullable_to_non_nullable
                      as StreamData?,
            velocitySmooth: freezed == velocitySmooth
                ? _value.velocitySmooth
                : velocitySmooth // ignore: cast_nullable_to_non_nullable
                      as StreamData?,
            altitude: freezed == altitude
                ? _value.altitude
                : altitude // ignore: cast_nullable_to_non_nullable
                      as StreamData?,
          )
          as $Val,
    );
  }

  /// Create a copy of ActivityStreams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StreamDataCopyWith<$Res>? get time {
    if (_value.time == null) {
      return null;
    }

    return $StreamDataCopyWith<$Res>(_value.time!, (value) {
      return _then(_value.copyWith(time: value) as $Val);
    });
  }

  /// Create a copy of ActivityStreams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StreamDataCopyWith<$Res>? get heartrate {
    if (_value.heartrate == null) {
      return null;
    }

    return $StreamDataCopyWith<$Res>(_value.heartrate!, (value) {
      return _then(_value.copyWith(heartrate: value) as $Val);
    });
  }

  /// Create a copy of ActivityStreams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StreamDataCopyWith<$Res>? get cadence {
    if (_value.cadence == null) {
      return null;
    }

    return $StreamDataCopyWith<$Res>(_value.cadence!, (value) {
      return _then(_value.copyWith(cadence: value) as $Val);
    });
  }

  /// Create a copy of ActivityStreams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StreamDataCopyWith<$Res>? get velocitySmooth {
    if (_value.velocitySmooth == null) {
      return null;
    }

    return $StreamDataCopyWith<$Res>(_value.velocitySmooth!, (value) {
      return _then(_value.copyWith(velocitySmooth: value) as $Val);
    });
  }

  /// Create a copy of ActivityStreams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StreamDataCopyWith<$Res>? get altitude {
    if (_value.altitude == null) {
      return null;
    }

    return $StreamDataCopyWith<$Res>(_value.altitude!, (value) {
      return _then(_value.copyWith(altitude: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityStreamsImplCopyWith<$Res>
    implements $ActivityStreamsCopyWith<$Res> {
  factory _$$ActivityStreamsImplCopyWith(
    _$ActivityStreamsImpl value,
    $Res Function(_$ActivityStreamsImpl) then,
  ) = __$$ActivityStreamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    StreamData? time,
    @JsonKey(name: 'heartrate') StreamData? heartrate,
    StreamData? cadence,
    @JsonKey(name: 'velocity_smooth') StreamData? velocitySmooth,
    StreamData? altitude,
  });

  @override
  $StreamDataCopyWith<$Res>? get time;
  @override
  $StreamDataCopyWith<$Res>? get heartrate;
  @override
  $StreamDataCopyWith<$Res>? get cadence;
  @override
  $StreamDataCopyWith<$Res>? get velocitySmooth;
  @override
  $StreamDataCopyWith<$Res>? get altitude;
}

/// @nodoc
class __$$ActivityStreamsImplCopyWithImpl<$Res>
    extends _$ActivityStreamsCopyWithImpl<$Res, _$ActivityStreamsImpl>
    implements _$$ActivityStreamsImplCopyWith<$Res> {
  __$$ActivityStreamsImplCopyWithImpl(
    _$ActivityStreamsImpl _value,
    $Res Function(_$ActivityStreamsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityStreams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = freezed,
    Object? heartrate = freezed,
    Object? cadence = freezed,
    Object? velocitySmooth = freezed,
    Object? altitude = freezed,
  }) {
    return _then(
      _$ActivityStreamsImpl(
        time: freezed == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as StreamData?,
        heartrate: freezed == heartrate
            ? _value.heartrate
            : heartrate // ignore: cast_nullable_to_non_nullable
                  as StreamData?,
        cadence: freezed == cadence
            ? _value.cadence
            : cadence // ignore: cast_nullable_to_non_nullable
                  as StreamData?,
        velocitySmooth: freezed == velocitySmooth
            ? _value.velocitySmooth
            : velocitySmooth // ignore: cast_nullable_to_non_nullable
                  as StreamData?,
        altitude: freezed == altitude
            ? _value.altitude
            : altitude // ignore: cast_nullable_to_non_nullable
                  as StreamData?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityStreamsImpl extends _ActivityStreams {
  const _$ActivityStreamsImpl({
    this.time,
    @JsonKey(name: 'heartrate') this.heartrate,
    this.cadence,
    @JsonKey(name: 'velocity_smooth') this.velocitySmooth,
    this.altitude,
  }) : super._();

  factory _$ActivityStreamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityStreamsImplFromJson(json);

  @override
  final StreamData? time;
  @override
  @JsonKey(name: 'heartrate')
  final StreamData? heartrate;
  @override
  final StreamData? cadence;
  @override
  @JsonKey(name: 'velocity_smooth')
  final StreamData? velocitySmooth;
  @override
  final StreamData? altitude;

  @override
  String toString() {
    return 'ActivityStreams(time: $time, heartrate: $heartrate, cadence: $cadence, velocitySmooth: $velocitySmooth, altitude: $altitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityStreamsImpl &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.heartrate, heartrate) ||
                other.heartrate == heartrate) &&
            (identical(other.cadence, cadence) || other.cadence == cadence) &&
            (identical(other.velocitySmooth, velocitySmooth) ||
                other.velocitySmooth == velocitySmooth) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    time,
    heartrate,
    cadence,
    velocitySmooth,
    altitude,
  );

  /// Create a copy of ActivityStreams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityStreamsImplCopyWith<_$ActivityStreamsImpl> get copyWith =>
      __$$ActivityStreamsImplCopyWithImpl<_$ActivityStreamsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityStreamsImplToJson(this);
  }
}

abstract class _ActivityStreams extends ActivityStreams {
  const factory _ActivityStreams({
    final StreamData? time,
    @JsonKey(name: 'heartrate') final StreamData? heartrate,
    final StreamData? cadence,
    @JsonKey(name: 'velocity_smooth') final StreamData? velocitySmooth,
    final StreamData? altitude,
  }) = _$ActivityStreamsImpl;
  const _ActivityStreams._() : super._();

  factory _ActivityStreams.fromJson(Map<String, dynamic> json) =
      _$ActivityStreamsImpl.fromJson;

  @override
  StreamData? get time;
  @override
  @JsonKey(name: 'heartrate')
  StreamData? get heartrate;
  @override
  StreamData? get cadence;
  @override
  @JsonKey(name: 'velocity_smooth')
  StreamData? get velocitySmooth;
  @override
  StreamData? get altitude;

  /// Create a copy of ActivityStreams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityStreamsImplCopyWith<_$ActivityStreamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StreamData _$StreamDataFromJson(Map<String, dynamic> json) {
  return _StreamData.fromJson(json);
}

/// @nodoc
mixin _$StreamData {
  String get type => throw _privateConstructorUsedError;
  List<double> get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'series_type')
  String? get seriesType => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_size')
  int? get originalSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'resolution')
  String? get resolution => throw _privateConstructorUsedError;

  /// Serializes this StreamData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StreamData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StreamDataCopyWith<StreamData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreamDataCopyWith<$Res> {
  factory $StreamDataCopyWith(
    StreamData value,
    $Res Function(StreamData) then,
  ) = _$StreamDataCopyWithImpl<$Res, StreamData>;
  @useResult
  $Res call({
    String type,
    List<double> data,
    @JsonKey(name: 'series_type') String? seriesType,
    @JsonKey(name: 'original_size') int? originalSize,
    @JsonKey(name: 'resolution') String? resolution,
  });
}

/// @nodoc
class _$StreamDataCopyWithImpl<$Res, $Val extends StreamData>
    implements $StreamDataCopyWith<$Res> {
  _$StreamDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StreamData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? data = null,
    Object? seriesType = freezed,
    Object? originalSize = freezed,
    Object? resolution = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            seriesType: freezed == seriesType
                ? _value.seriesType
                : seriesType // ignore: cast_nullable_to_non_nullable
                      as String?,
            originalSize: freezed == originalSize
                ? _value.originalSize
                : originalSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            resolution: freezed == resolution
                ? _value.resolution
                : resolution // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StreamDataImplCopyWith<$Res>
    implements $StreamDataCopyWith<$Res> {
  factory _$$StreamDataImplCopyWith(
    _$StreamDataImpl value,
    $Res Function(_$StreamDataImpl) then,
  ) = __$$StreamDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String type,
    List<double> data,
    @JsonKey(name: 'series_type') String? seriesType,
    @JsonKey(name: 'original_size') int? originalSize,
    @JsonKey(name: 'resolution') String? resolution,
  });
}

/// @nodoc
class __$$StreamDataImplCopyWithImpl<$Res>
    extends _$StreamDataCopyWithImpl<$Res, _$StreamDataImpl>
    implements _$$StreamDataImplCopyWith<$Res> {
  __$$StreamDataImplCopyWithImpl(
    _$StreamDataImpl _value,
    $Res Function(_$StreamDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StreamData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? data = null,
    Object? seriesType = freezed,
    Object? originalSize = freezed,
    Object? resolution = freezed,
  }) {
    return _then(
      _$StreamDataImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        seriesType: freezed == seriesType
            ? _value.seriesType
            : seriesType // ignore: cast_nullable_to_non_nullable
                  as String?,
        originalSize: freezed == originalSize
            ? _value.originalSize
            : originalSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        resolution: freezed == resolution
            ? _value.resolution
            : resolution // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamDataImpl implements _StreamData {
  const _$StreamDataImpl({
    required this.type,
    required final List<double> data,
    @JsonKey(name: 'series_type') this.seriesType,
    @JsonKey(name: 'original_size') this.originalSize,
    @JsonKey(name: 'resolution') this.resolution,
  }) : _data = data;

  factory _$StreamDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreamDataImplFromJson(json);

  @override
  final String type;
  final List<double> _data;
  @override
  List<double> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  @JsonKey(name: 'series_type')
  final String? seriesType;
  @override
  @JsonKey(name: 'original_size')
  final int? originalSize;
  @override
  @JsonKey(name: 'resolution')
  final String? resolution;

  @override
  String toString() {
    return 'StreamData(type: $type, data: $data, seriesType: $seriesType, originalSize: $originalSize, resolution: $resolution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamDataImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.seriesType, seriesType) ||
                other.seriesType == seriesType) &&
            (identical(other.originalSize, originalSize) ||
                other.originalSize == originalSize) &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(_data),
    seriesType,
    originalSize,
    resolution,
  );

  /// Create a copy of StreamData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StreamDataImplCopyWith<_$StreamDataImpl> get copyWith =>
      __$$StreamDataImplCopyWithImpl<_$StreamDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamDataImplToJson(this);
  }
}

abstract class _StreamData implements StreamData {
  const factory _StreamData({
    required final String type,
    required final List<double> data,
    @JsonKey(name: 'series_type') final String? seriesType,
    @JsonKey(name: 'original_size') final int? originalSize,
    @JsonKey(name: 'resolution') final String? resolution,
  }) = _$StreamDataImpl;

  factory _StreamData.fromJson(Map<String, dynamic> json) =
      _$StreamDataImpl.fromJson;

  @override
  String get type;
  @override
  List<double> get data;
  @override
  @JsonKey(name: 'series_type')
  String? get seriesType;
  @override
  @JsonKey(name: 'original_size')
  int? get originalSize;
  @override
  @JsonKey(name: 'resolution')
  String? get resolution;

  /// Create a copy of StreamData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StreamDataImplCopyWith<_$StreamDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
