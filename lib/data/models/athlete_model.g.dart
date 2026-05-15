// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'athlete_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AthleteModelImpl _$$AthleteModelImplFromJson(Map<String, dynamic> json) =>
    _$AthleteModelImpl(
      id: (json['id'] as num).toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      profileMedium: json['profile_medium'] as String?,
      profile: json['profile'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      sex: json['sex'] as String?,
      premium: json['premium'] as bool?,
      maxHeartrate: (json['max_heartrate'] as num?)?.toDouble(),
      ftp: (json['ftp'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$AthleteModelImplToJson(_$AthleteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'profile_medium': instance.profileMedium,
      'profile': instance.profile,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'sex': instance.sex,
      'premium': instance.premium,
      'max_heartrate': instance.maxHeartrate,
      'ftp': instance.ftp,
      'weight': instance.weight,
    };
