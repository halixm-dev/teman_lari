import 'package:freezed_annotation/freezed_annotation.dart';

part 'strava_tokens.freezed.dart';
part 'strava_tokens.g.dart';

@freezed
abstract class StravaTokens with _$StravaTokens {
  const StravaTokens._();

  const factory StravaTokens({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_at') required int expiresAt,
  }) = _StravaTokens;

  factory StravaTokens.fromJson(Map<String, dynamic> json) =>
      _$StravaTokensFromJson(json);
}
