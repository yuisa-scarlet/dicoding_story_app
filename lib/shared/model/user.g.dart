// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSession _$UserSessionFromJson(Map<String, dynamic> json) => UserSession(
  userId: json['userId'] as String? ?? '',
  name: json['name'] as String? ?? '',
  token: json['token'] as String? ?? '',
);

Map<String, dynamic> _$UserSessionToJson(UserSession instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'token': instance.token,
    };
