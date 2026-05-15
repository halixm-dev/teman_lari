// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strava_tokens.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StravaTokensImpl _$$StravaTokensImplFromJson(Map<String, dynamic> json) =>
    _$StravaTokensImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: (json['expires_at'] as num).toInt(),
    );

Map<String, dynamic> _$$StravaTokensImplToJson(_$StravaTokensImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_at': instance.expiresAt,
    };
