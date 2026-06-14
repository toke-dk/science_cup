// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Team _$TeamFromJson(Map<String, dynamic> json) => _Team(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  season: json['season'] == null
      ? null
      : Season.fromJson(json['season'] as Map<String, dynamic>),
  program: json['program'] == null
      ? null
      : Program.fromJson(json['program'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TeamToJson(_Team instance) => <String, dynamic>{
  'id': ?instance.id,
  'name': ?instance.name,
  'created_at': ?instance.createdAt?.toIso8601String(),
  'season': ?instance.season,
  'program': ?instance.program,
};
