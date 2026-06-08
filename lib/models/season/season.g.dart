// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Season _$SeasonFromJson(Map<String, dynamic> json) => _Season(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$SeasonToJson(_Season instance) => <String, dynamic>{
  'id': ?instance.id,
  'name': ?instance.name,
  'start_date': ?instance.startDate?.toIso8601String(),
  'end_date': ?instance.endDate?.toIso8601String(),
  'created_at': ?instance.createdAt?.toIso8601String(),
};
