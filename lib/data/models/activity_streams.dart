import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_streams.freezed.dart';
part 'activity_streams.g.dart';

@freezed
class ActivityStreams with _$ActivityStreams {
  const ActivityStreams._();

  const factory ActivityStreams({
    StreamData? time,
    @JsonKey(name: 'heartrate') StreamData? heartrate,
    StreamData? cadence,
    @JsonKey(name: 'velocity_smooth') StreamData? velocitySmooth,
    StreamData? altitude,
  }) = _ActivityStreams;

  factory ActivityStreams.fromJson(Map<String, dynamic> json) =>
      _$ActivityStreamsFromJson(json);
}

@freezed
class StreamData with _$StreamData {
  const factory StreamData({
    required String type,
    required List<double> data,
    @JsonKey(name: 'series_type') String? seriesType,
    @JsonKey(name: 'original_size') int? originalSize,
    @JsonKey(name: 'resolution') String? resolution,
  }) = _StreamData;

  factory StreamData.fromJson(Map<String, dynamic> json) =>
      _$StreamDataFromJson(json);
}
