// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  role: $enumDecodeNullable(_$ProfileRoleEnumMap, json['role']),
  name: json['name'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': ?instance.id,
  'email': ?instance.email,
  'phone': ?instance.phone,
  'role': ?_$ProfileRoleEnumMap[instance.role],
  'name': ?instance.name,
  'created_at': ?instance.createdAt?.toIso8601String(),
};

const _$ProfileRoleEnumMap = {
  ProfileRole.admin: 'admin',
  ProfileRole.groupContact: 'groupContact',
};
