// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Group _$GroupFromJson(Map<String, dynamic> json) => _Group(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  season: json['season'] == null
      ? null
      : Season.fromJson(json['season'] as Map<String, dynamic>),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$GroupToJson(_Group instance) => <String, dynamic>{
  'id': ?instance.id,
  'name': ?instance.name,
  'season': ?instance.season,
  'created_at': ?instance.createdAt?.toIso8601String(),
};
