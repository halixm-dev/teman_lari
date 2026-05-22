import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_streams.freezed.dart';
part 'activity_streams.g.dart';

@freezed
abstract class ActivityStreams with _$ActivityStreams {
  const ActivityStreams._();

  const factory ActivityStreams({
    StreamData? time,
    StreamData? heartrate,
    StreamData? cadence,
    StreamData? velocitySmooth,
    StreamData? altitude,
  }) = _ActivityStreams;

  factory ActivityStreams.fromJson(Map<String, dynamic> json) =>
      _$ActivityStreamsFromJson(json);
}

@freezed
abstract class StreamData with _$StreamData {
  const StreamData._();

  const factory StreamData({
    required String type,
    required List<double> data,
    String? seriesType,
    int? originalSize,
    String? resolution,
  }) = _StreamData;

  factory StreamData.fromJson(Map<String, dynamic> json) =>
      _$StreamDataFromJson(json);
}
