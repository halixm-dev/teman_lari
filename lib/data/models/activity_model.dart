import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_model.freezed.dart';
part 'activity_model.g.dart';

@freezed
abstract class ActivityModel with _$ActivityModel {
  const ActivityModel._();

  const factory ActivityModel({
    required int id,
    required String name,
    required String type,
    required double distance,
    @JsonKey(name: 'moving_time') required int movingTime,
    @JsonKey(name: 'elapsed_time') required int elapsedTime,
    @JsonKey(name: 'total_elevation_gain') required double totalElevationGain,
    @JsonKey(name: 'start_date') required String startDate,
    @JsonKey(name: 'average_speed') required double averageSpeed,
    @JsonKey(name: 'max_speed') required double maxSpeed,
    @JsonKey(name: 'average_heartrate') double? averageHeartrate,
    @JsonKey(name: 'max_heartrate') double? maxHeartrate,
    @JsonKey(name: 'average_cadence') double? averageCadence,
    @JsonKey(name: 'suffer_score') int? sufferScore,
    @JsonKey(name: 'has_heartrate') @Default(false) bool hasHeartrate,
    @JsonKey(name: 'workout_type') int? workoutType,
    @JsonKey(name: 'perceived_exertion') double? perceivedExertion,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);
}
