import 'package:freezed_annotation/freezed_annotation.dart';

part 'athlete_model.freezed.dart';
part 'athlete_model.g.dart';

@freezed
abstract class AthleteModel with _$AthleteModel {
  const AthleteModel._();

  const factory AthleteModel({
    required int id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'profile_medium') String? profileMedium,
    String? profile,
    String? city,
    String? state,
    String? country,
    @JsonKey(name: 'sex') String? sex,
    @JsonKey(name: 'premium') bool? premium,
    @JsonKey(name: 'date_of_birth') String? dateOfBirth,
    @JsonKey(name: 'max_heartrate') double? maxHeartrate,
    @JsonKey(name: 'ftp') int? ftp,
    @JsonKey(name: 'weight') double? weight,
  }) = _AthleteModel;

  factory AthleteModel.fromJson(Map<String, dynamic> json) =>
      _$AthleteModelFromJson(json);
}
