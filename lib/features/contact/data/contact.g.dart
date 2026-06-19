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
  team: json['team'] == null
      ? null
      : Team.fromJson(json['team'] as Map<String, dynamic>),
  isPrimary: json['is_primary'] as bool?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'id': ?instance.id,
  'profile': ?instance.profile,
  'team': ?instance.team,
  'is_primary': ?instance.isPrimary,
  'created_at': ?instance.createdAt?.toIso8601String(),
};
