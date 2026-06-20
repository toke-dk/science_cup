// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
  id: (json['id'] as num?)?.toInt(),
  profile: json['profile'] == null
      ? null
      : Profile.fromJson(json['profile'] as Map<String, dynamic>),
  isPrimary: json['is_primary'] as bool?,
  fallbackName: json['fallback_name'] as String?,
  fallbackPhone: json['fallback_phone'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  teams: (json['teams'] as List<dynamic>?)
      ?.map((e) => Team.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'id': ?instance.id,
  'profile': ?instance.profile,
  'is_primary': ?instance.isPrimary,
  'fallback_name': ?instance.fallbackName,
  'fallback_phone': ?instance.fallbackPhone,
  'created_at': ?instance.createdAt?.toIso8601String(),
  'teams': ?instance.teams,
};
