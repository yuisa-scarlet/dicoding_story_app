import 'package:intl/intl.dart';

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

  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '-',
      description: json['description'] as String? ?? '-',
      photoUrl: json['photoUrl'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      lat: _parseDouble(json['lat']),
      lon: _parseDouble(json['lon']),
    );
  }

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
}
