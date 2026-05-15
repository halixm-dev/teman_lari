// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strava_tokens.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StravaTokens _$StravaTokensFromJson(Map<String, dynamic> json) =>
    _StravaTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: (json['expires_at'] as num).toInt(),
    );

Map<String, dynamic> _$StravaTokensToJson(_StravaTokens instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_at': instance.expiresAt,
    };
