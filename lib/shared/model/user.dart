import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserSession {
  const UserSession({
    required this.userId,
    required this.name,
    required this.token,
  });

  @JsonKey(defaultValue: '')
  final String userId;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String token;

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSessionToJson(this);
}
