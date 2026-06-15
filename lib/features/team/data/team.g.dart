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
  seasonId: (json['season_id'] as num?)?.toInt(),
  program: json['program'] == null
      ? null
      : Program.fromJson(json['program'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TeamToJson(_Team instance) => <String, dynamic>{
  'id': ?instance.id,
  'name': ?instance.name,
  'created_at': ?instance.createdAt?.toIso8601String(),
  'season_id': ?instance.seasonId,
  'program': ?instance.program,
};
