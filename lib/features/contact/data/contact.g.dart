// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  phoneNumber: json['phone_number'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'id': ?instance.id,
  'name': ?instance.name,
  'phone_number': ?instance.phoneNumber,
  'created_at': ?instance.createdAt?.toIso8601String(),
};
