// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_streams.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityStreams _$ActivityStreamsFromJson(Map<String, dynamic> json) =>
    _ActivityStreams(
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
          : StreamData.fromJson(
              json['velocity_smooth'] as Map<String, dynamic>,
            ),
      altitude: json['altitude'] == null
          ? null
          : StreamData.fromJson(json['altitude'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityStreamsToJson(_ActivityStreams instance) =>
    <String, dynamic>{
      'time': instance.time,
      'heartrate': instance.heartrate,
      'cadence': instance.cadence,
      'velocity_smooth': instance.velocitySmooth,
      'altitude': instance.altitude,
    };

_StreamData _$StreamDataFromJson(Map<String, dynamic> json) => _StreamData(
  type: json['type'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  seriesType: json['series_type'] as String?,
  originalSize: (json['original_size'] as num?)?.toInt(),
  resolution: json['resolution'] as String?,
);

Map<String, dynamic> _$StreamDataToJson(_StreamData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
      'series_type': instance.seriesType,
      'original_size': instance.originalSize,
      'resolution': instance.resolution,
    };
