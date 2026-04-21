import 'package:json_annotation/json_annotation.dart';

import 'story.dart';
import 'user.dart';

part 'api_response.g.dart';

@JsonSerializable()
class BasicResponse {
  const BasicResponse({required this.error, required this.message});

  @JsonKey(defaultValue: true)
  final bool error;
  @JsonKey(defaultValue: '')
  final String message;

  factory BasicResponse.fromJson(Map<String, dynamic> json) =>
      _$BasicResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BasicResponseToJson(this);
}

@JsonSerializable()
class LoginResponse {
  const LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  @JsonKey(defaultValue: true)
  final bool error;
  @JsonKey(defaultValue: '')
  final String message;
  final UserSession? loginResult;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class StoryListResponse {
  const StoryListResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  @JsonKey(defaultValue: true)
  final bool error;
  @JsonKey(defaultValue: '')
  final String message;
  @JsonKey(defaultValue: <StoryModel>[])
  final List<StoryModel> listStory;

  factory StoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryListResponseToJson(this);
}

@JsonSerializable()
class StoryDetailResponse {
  const StoryDetailResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  @JsonKey(defaultValue: true)
  final bool error;
  @JsonKey(defaultValue: '')
  final String message;
  final StoryModel? story;

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryDetailResponseToJson(this);
}
