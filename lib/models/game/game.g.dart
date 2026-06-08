// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Game _$GameFromJson(Map<String, dynamic> json) => _Game(
  id: (json['id'] as num).toInt(),
  season: json['season'] == null
      ? null
      : Season.fromJson(json['season'] as Map<String, dynamic>),
  homeTeam: json['home_team'] == null
      ? null
      : Team.fromJson(json['home_team'] as Map<String, dynamic>),
  awayTeam: json['away_team'] == null
      ? null
      : Team.fromJson(json['away_team'] as Map<String, dynamic>),
  homeScore: (json['home_score'] as num?)?.toInt(),
  awayScore: (json['away_score'] as num?)?.toInt(),
  group: json['group'] == null
      ? null
      : Group.fromJson(json['group'] as Map<String, dynamic>),
  refereeAbsent: json['referee_absent'] as bool?,
  comment: json['comment'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  refereeTeam: json['referee_team'] == null
      ? null
      : Team.fromJson(json['referee_team'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GameToJson(_Game instance) => <String, dynamic>{
  'id': instance.id,
  'season': instance.season,
  'home_team': instance.homeTeam,
  'away_team': instance.awayTeam,
  'home_score': instance.homeScore,
  'away_score': instance.awayScore,
  'group': instance.group,
  'referee_absent': instance.refereeAbsent,
  'comment': instance.comment,
  'created_at': instance.createdAt?.toIso8601String(),
  'start_date': instance.startDate?.toIso8601String(),
  'referee_team': instance.refereeTeam,
};
