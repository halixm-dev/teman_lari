// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_streams.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityStreams {

 StreamData? get time;@JsonKey(name: 'heartrate') StreamData? get heartrate; StreamData? get cadence;@JsonKey(name: 'velocity_smooth') StreamData? get velocitySmooth; StreamData? get altitude;
/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityStreamsCopyWith<ActivityStreams> get copyWith => _$ActivityStreamsCopyWithImpl<ActivityStreams>(this as ActivityStreams, _$identity);

  /// Serializes this ActivityStreams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityStreams&&(identical(other.time, time) || other.time == time)&&(identical(other.heartrate, heartrate) || other.heartrate == heartrate)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.velocitySmooth, velocitySmooth) || other.velocitySmooth == velocitySmooth)&&(identical(other.altitude, altitude) || other.altitude == altitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,heartrate,cadence,velocitySmooth,altitude);

@override
String toString() {
  return 'ActivityStreams(time: $time, heartrate: $heartrate, cadence: $cadence, velocitySmooth: $velocitySmooth, altitude: $altitude)';
}


}

/// @nodoc
abstract mixin class $ActivityStreamsCopyWith<$Res>  {
  factory $ActivityStreamsCopyWith(ActivityStreams value, $Res Function(ActivityStreams) _then) = _$ActivityStreamsCopyWithImpl;
@useResult
$Res call({
 StreamData? time,@JsonKey(name: 'heartrate') StreamData? heartrate, StreamData? cadence,@JsonKey(name: 'velocity_smooth') StreamData? velocitySmooth, StreamData? altitude
});


$StreamDataCopyWith<$Res>? get time;$StreamDataCopyWith<$Res>? get heartrate;$StreamDataCopyWith<$Res>? get cadence;$StreamDataCopyWith<$Res>? get velocitySmooth;$StreamDataCopyWith<$Res>? get altitude;

}
/// @nodoc
class _$ActivityStreamsCopyWithImpl<$Res>
    implements $ActivityStreamsCopyWith<$Res> {
  _$ActivityStreamsCopyWithImpl(this._self, this._then);

  final ActivityStreams _self;
  final $Res Function(ActivityStreams) _then;

/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = freezed,Object? heartrate = freezed,Object? cadence = freezed,Object? velocitySmooth = freezed,Object? altitude = freezed,}) {
  return _then(_self.copyWith(
time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as StreamData?,heartrate: freezed == heartrate ? _self.heartrate : heartrate // ignore: cast_nullable_to_non_nullable
as StreamData?,cadence: freezed == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as StreamData?,velocitySmooth: freezed == velocitySmooth ? _self.velocitySmooth : velocitySmooth // ignore: cast_nullable_to_non_nullable
as StreamData?,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as StreamData?,
  ));
}
/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreamDataCopyWith<$Res>? get time {
    if (_self.time == null) {
    return null;
  }

  return $StreamDataCopyWith<$Res>(_self.time!, (value) {
    return _then(_self.copyWith(time: value));
  });
}/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreamDataCopyWith<$Res>? get heartrate {
    if (_self.heartrate == null) {
    return null;
  }

  return $StreamDataCopyWith<$Res>(_self.heartrate!, (value) {
    return _then(_self.copyWith(heartrate: value));
  });
}/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreamDataCopyWith<$Res>? get cadence {
    if (_self.cadence == null) {
    return null;
  }

  return $StreamDataCopyWith<$Res>(_self.cadence!, (value) {
    return _then(_self.copyWith(cadence: value));
  });
}/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreamDataCopyWith<$Res>? get velocitySmooth {
    if (_self.velocitySmooth == null) {
    return null;
  }

  return $StreamDataCopyWith<$Res>(_self.velocitySmooth!, (value) {
    return _then(_self.copyWith(velocitySmooth: value));
  });
}/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreamDataCopyWith<$Res>? get altitude {
    if (_self.altitude == null) {
    return null;
  }

  return $StreamDataCopyWith<$Res>(_self.altitude!, (value) {
    return _then(_self.copyWith(altitude: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivityStreams].
extension ActivityStreamsPatterns on ActivityStreams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityStreams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityStreams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityStreams value)  $default,){
final _that = this;
switch (_that) {
case _ActivityStreams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityStreams value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityStreams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StreamData? time, @JsonKey(name: 'heartrate')  StreamData? heartrate,  StreamData? cadence, @JsonKey(name: 'velocity_smooth')  StreamData? velocitySmooth,  StreamData? altitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityStreams() when $default != null:
return $default(_that.time,_that.heartrate,_that.cadence,_that.velocitySmooth,_that.altitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StreamData? time, @JsonKey(name: 'heartrate')  StreamData? heartrate,  StreamData? cadence, @JsonKey(name: 'velocity_smooth')  StreamData? velocitySmooth,  StreamData? altitude)  $default,) {final _that = this;
switch (_that) {
case _ActivityStreams():
return $default(_that.time,_that.heartrate,_that.cadence,_that.velocitySmooth,_that.altitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StreamData? time, @JsonKey(name: 'heartrate')  StreamData? heartrate,  StreamData? cadence, @JsonKey(name: 'velocity_smooth')  StreamData? velocitySmooth,  StreamData? altitude)?  $default,) {final _that = this;
switch (_that) {
case _ActivityStreams() when $default != null:
return $default(_that.time,_that.heartrate,_that.cadence,_that.velocitySmooth,_that.altitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityStreams extends ActivityStreams {
  const _ActivityStreams({this.time, @JsonKey(name: 'heartrate') this.heartrate, this.cadence, @JsonKey(name: 'velocity_smooth') this.velocitySmooth, this.altitude}): super._();
  factory _ActivityStreams.fromJson(Map<String, dynamic> json) => _$ActivityStreamsFromJson(json);

@override final  StreamData? time;
@override@JsonKey(name: 'heartrate') final  StreamData? heartrate;
@override final  StreamData? cadence;
@override@JsonKey(name: 'velocity_smooth') final  StreamData? velocitySmooth;
@override final  StreamData? altitude;

/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityStreamsCopyWith<_ActivityStreams> get copyWith => __$ActivityStreamsCopyWithImpl<_ActivityStreams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityStreamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityStreams&&(identical(other.time, time) || other.time == time)&&(identical(other.heartrate, heartrate) || other.heartrate == heartrate)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.velocitySmooth, velocitySmooth) || other.velocitySmooth == velocitySmooth)&&(identical(other.altitude, altitude) || other.altitude == altitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,heartrate,cadence,velocitySmooth,altitude);

@override
String toString() {
  return 'ActivityStreams(time: $time, heartrate: $heartrate, cadence: $cadence, velocitySmooth: $velocitySmooth, altitude: $altitude)';
}


}

/// @nodoc
abstract mixin class _$ActivityStreamsCopyWith<$Res> implements $ActivityStreamsCopyWith<$Res> {
  factory _$ActivityStreamsCopyWith(_ActivityStreams value, $Res Function(_ActivityStreams) _then) = __$ActivityStreamsCopyWithImpl;
@override @useResult
$Res call({
 StreamData? time,@JsonKey(name: 'heartrate') StreamData? heartrate, StreamData? cadence,@JsonKey(name: 'velocity_smooth') StreamData? velocitySmooth, StreamData? altitude
});


@override $StreamDataCopyWith<$Res>? get time;@override $StreamDataCopyWith<$Res>? get heartrate;@override $StreamDataCopyWith<$Res>? get cadence;@override $StreamDataCopyWith<$Res>? get velocitySmooth;@override $StreamDataCopyWith<$Res>? get altitude;

}
/// @nodoc
class __$ActivityStreamsCopyWithImpl<$Res>
    implements _$ActivityStreamsCopyWith<$Res> {
  __$ActivityStreamsCopyWithImpl(this._self, this._then);

  final _ActivityStreams _self;
  final $Res Function(_ActivityStreams) _then;

/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = freezed,Object? heartrate = freezed,Object? cadence = freezed,Object? velocitySmooth = freezed,Object? altitude = freezed,}) {
  return _then(_ActivityStreams(
time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as StreamData?,heartrate: freezed == heartrate ? _self.heartrate : heartrate // ignore: cast_nullable_to_non_nullable
as StreamData?,cadence: freezed == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as StreamData?,velocitySmooth: freezed == velocitySmooth ? _self.velocitySmooth : velocitySmooth // ignore: cast_nullable_to_non_nullable
as StreamData?,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as StreamData?,
  ));
}

/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreamDataCopyWith<$Res>? get time {
    if (_self.time == null) {
    return null;
  }

  return $StreamDataCopyWith<$Res>(_self.time!, (value) {
    return _then(_self.copyWith(time: value));
  });
}/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreamDataCopyWith<$Res>? get heartrate {
    if (_self.heartrate == null) {
    return null;
  }

  return $StreamDataCopyWith<$Res>(_self.heartrate!, (value) {
    return _then(_self.copyWith(heartrate: value));
  });
}/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreamDataCopyWith<$Res>? get cadence {
    if (_self.cadence == null) {
    return null;
  }

  return $StreamDataCopyWith<$Res>(_self.cadence!, (value) {
    return _then(_self.copyWith(cadence: value));
  });
}/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreamDataCopyWith<$Res>? get velocitySmooth {
    if (_self.velocitySmooth == null) {
    return null;
  }

  return $StreamDataCopyWith<$Res>(_self.velocitySmooth!, (value) {
    return _then(_self.copyWith(velocitySmooth: value));
  });
}/// Create a copy of ActivityStreams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreamDataCopyWith<$Res>? get altitude {
    if (_self.altitude == null) {
    return null;
  }

  return $StreamDataCopyWith<$Res>(_self.altitude!, (value) {
    return _then(_self.copyWith(altitude: value));
  });
}
}


/// @nodoc
mixin _$StreamData {

 String get type; List<double> get data;@JsonKey(name: 'series_type') String? get seriesType;@JsonKey(name: 'original_size') int? get originalSize;@JsonKey(name: 'resolution') String? get resolution;
/// Create a copy of StreamData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreamDataCopyWith<StreamData> get copyWith => _$StreamDataCopyWithImpl<StreamData>(this as StreamData, _$identity);

  /// Serializes this StreamData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreamData&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.seriesType, seriesType) || other.seriesType == seriesType)&&(identical(other.originalSize, originalSize) || other.originalSize == originalSize)&&(identical(other.resolution, resolution) || other.resolution == resolution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(data),seriesType,originalSize,resolution);

@override
String toString() {
  return 'StreamData(type: $type, data: $data, seriesType: $seriesType, originalSize: $originalSize, resolution: $resolution)';
}


}

/// @nodoc
abstract mixin class $StreamDataCopyWith<$Res>  {
  factory $StreamDataCopyWith(StreamData value, $Res Function(StreamData) _then) = _$StreamDataCopyWithImpl;
@useResult
$Res call({
 String type, List<double> data,@JsonKey(name: 'series_type') String? seriesType,@JsonKey(name: 'original_size') int? originalSize,@JsonKey(name: 'resolution') String? resolution
});




}
/// @nodoc
class _$StreamDataCopyWithImpl<$Res>
    implements $StreamDataCopyWith<$Res> {
  _$StreamDataCopyWithImpl(this._self, this._then);

  final StreamData _self;
  final $Res Function(StreamData) _then;

/// Create a copy of StreamData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? data = null,Object? seriesType = freezed,Object? originalSize = freezed,Object? resolution = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<double>,seriesType: freezed == seriesType ? _self.seriesType : seriesType // ignore: cast_nullable_to_non_nullable
as String?,originalSize: freezed == originalSize ? _self.originalSize : originalSize // ignore: cast_nullable_to_non_nullable
as int?,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StreamData].
extension StreamDataPatterns on StreamData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreamData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreamData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreamData value)  $default,){
final _that = this;
switch (_that) {
case _StreamData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreamData value)?  $default,){
final _that = this;
switch (_that) {
case _StreamData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  List<double> data, @JsonKey(name: 'series_type')  String? seriesType, @JsonKey(name: 'original_size')  int? originalSize, @JsonKey(name: 'resolution')  String? resolution)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreamData() when $default != null:
return $default(_that.type,_that.data,_that.seriesType,_that.originalSize,_that.resolution);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  List<double> data, @JsonKey(name: 'series_type')  String? seriesType, @JsonKey(name: 'original_size')  int? originalSize, @JsonKey(name: 'resolution')  String? resolution)  $default,) {final _that = this;
switch (_that) {
case _StreamData():
return $default(_that.type,_that.data,_that.seriesType,_that.originalSize,_that.resolution);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  List<double> data, @JsonKey(name: 'series_type')  String? seriesType, @JsonKey(name: 'original_size')  int? originalSize, @JsonKey(name: 'resolution')  String? resolution)?  $default,) {final _that = this;
switch (_that) {
case _StreamData() when $default != null:
return $default(_that.type,_that.data,_that.seriesType,_that.originalSize,_that.resolution);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StreamData extends StreamData {
  const _StreamData({required this.type, required final  List<double> data, @JsonKey(name: 'series_type') this.seriesType, @JsonKey(name: 'original_size') this.originalSize, @JsonKey(name: 'resolution') this.resolution}): _data = data,super._();
  factory _StreamData.fromJson(Map<String, dynamic> json) => _$StreamDataFromJson(json);

@override final  String type;
 final  List<double> _data;
@override List<double> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey(name: 'series_type') final  String? seriesType;
@override@JsonKey(name: 'original_size') final  int? originalSize;
@override@JsonKey(name: 'resolution') final  String? resolution;

/// Create a copy of StreamData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreamDataCopyWith<_StreamData> get copyWith => __$StreamDataCopyWithImpl<_StreamData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreamDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreamData&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.seriesType, seriesType) || other.seriesType == seriesType)&&(identical(other.originalSize, originalSize) || other.originalSize == originalSize)&&(identical(other.resolution, resolution) || other.resolution == resolution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_data),seriesType,originalSize,resolution);

@override
String toString() {
  return 'StreamData(type: $type, data: $data, seriesType: $seriesType, originalSize: $originalSize, resolution: $resolution)';
}


}

/// @nodoc
abstract mixin class _$StreamDataCopyWith<$Res> implements $StreamDataCopyWith<$Res> {
  factory _$StreamDataCopyWith(_StreamData value, $Res Function(_StreamData) _then) = __$StreamDataCopyWithImpl;
@override @useResult
$Res call({
 String type, List<double> data,@JsonKey(name: 'series_type') String? seriesType,@JsonKey(name: 'original_size') int? originalSize,@JsonKey(name: 'resolution') String? resolution
});




}
/// @nodoc
class __$StreamDataCopyWithImpl<$Res>
    implements _$StreamDataCopyWith<$Res> {
  __$StreamDataCopyWithImpl(this._self, this._then);

  final _StreamData _self;
  final $Res Function(_StreamData) _then;

/// Create a copy of StreamData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? data = null,Object? seriesType = freezed,Object? originalSize = freezed,Object? resolution = freezed,}) {
  return _then(_StreamData(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<double>,seriesType: freezed == seriesType ? _self.seriesType : seriesType // ignore: cast_nullable_to_non_nullable
as String?,originalSize: freezed == originalSize ? _self.originalSize : originalSize // ignore: cast_nullable_to_non_nullable
as int?,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
