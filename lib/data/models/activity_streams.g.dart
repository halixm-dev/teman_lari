// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_streams.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityStreamsImpl _$$ActivityStreamsImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityStreamsImpl(
  time: json['time'] == null
      ? null
      : StreamData.fromJson(json['time'] as Map<String, dynamic>),
  heartrate: json['heartrate'] == null
      ? null
      : StreamData.fromJson(json['heartrate'] as Map<String, dynamic>),
  cadence: json['cadence'] == null
      ? null
      : StreamData.fromJson(json['cadence'] as Map<String, dynamic>),
  velocitySmooth: json['velocity_smooth'] == null
      ? null
      : StreamData.fromJson(json['velocity_smooth'] as Map<String, dynamic>),
  altitude: json['altitude'] == null
      ? null
      : StreamData.fromJson(json['altitude'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ActivityStreamsImplToJson(
  _$ActivityStreamsImpl instance,
) => <String, dynamic>{
  'time': instance.time,
  'heartrate': instance.heartrate,
  'cadence': instance.cadence,
  'velocity_smooth': instance.velocitySmooth,
  'altitude': instance.altitude,
};

_$StreamDataImpl _$$StreamDataImplFromJson(Map<String, dynamic> json) =>
    _$StreamDataImpl(
      type: json['type'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      seriesType: json['series_type'] as String?,
      originalSize: (json['original_size'] as num?)?.toInt(),
      resolution: json['resolution'] as String?,
    );

Map<String, dynamic> _$$StreamDataImplToJson(_$StreamDataImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
      'series_type': instance.seriesType,
      'original_size': instance.originalSize,
      'resolution': instance.resolution,
    };
