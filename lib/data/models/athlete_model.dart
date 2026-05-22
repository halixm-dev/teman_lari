import 'package:freezed_annotation/freezed_annotation.dart';

part 'athlete_model.freezed.dart';
part 'athlete_model.g.dart';

@freezed
abstract class AthleteModel with _$AthleteModel {
  const AthleteModel._();

  const factory AthleteModel({
    required int id,
    String? firstName,
    String? lastName,
    String? profileMedium,
    String? profile,
    String? city,
    String? state,
    String? country,
    String? sex,
    bool? premium,
    String? dateOfBirth,
    double? maxHeartrate,
    int? ftp,
    double? weight,
  }) = _AthleteModel;

  factory AthleteModel.fromJson(Map<String, dynamic> json) =>
      _$AthleteModelFromJson(json);
}
