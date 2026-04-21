// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => StoryModel(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '-',
  description: json['description'] as String? ?? '-',
  photoUrl: json['photoUrl'] as String? ?? '',
  createdAt: StoryModel._parseDateTime(json['createdAt']),
  lat: StoryModel._parseDouble(json['lat']),
  lon: StoryModel._parseDouble(json['lon']),
);

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'lat': instance.lat,
      'lon': instance.lon,
    };
