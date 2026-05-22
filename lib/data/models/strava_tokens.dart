import 'package:freezed_annotation/freezed_annotation.dart';

part 'strava_tokens.freezed.dart';
part 'strava_tokens.g.dart';

@freezed
abstract class StravaTokens with _$StravaTokens {
  const StravaTokens._();

  const factory StravaTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresAt,
  }) = _StravaTokens;

  factory StravaTokens.fromJson(Map<String, dynamic> json) =>
      _$StravaTokensFromJson(json);
}
