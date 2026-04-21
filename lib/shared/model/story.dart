import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class StoryModel {
  const StoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '-')
  final String name;
  @JsonKey(defaultValue: '-')
  final String description;
  @JsonKey(defaultValue: '')
  final String photoUrl;
  @JsonKey(fromJson: _parseDateTime)
  final DateTime createdAt;
  @JsonKey(fromJson: _parseDouble)
  final double? lat;
  @JsonKey(fromJson: _parseDouble)
  final double? lon;

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryModelToJson(this);

  static double? _parseDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  String get formattedCreatedAt {
    return DateFormat.yMMMd().add_Hm().format(createdAt.toLocal());
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }
}
