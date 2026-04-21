// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasicResponse _$BasicResponseFromJson(Map<String, dynamic> json) =>
    BasicResponse(
      error: json['error'] as bool? ?? true,
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$BasicResponseToJson(BasicResponse instance) =>
    <String, dynamic>{'error': instance.error, 'message': instance.message};

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      error: json['error'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      loginResult: json['loginResult'] == null
          ? null
          : UserSession.fromJson(json['loginResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'loginResult': instance.loginResult,
    };

StoryListResponse _$StoryListResponseFromJson(Map<String, dynamic> json) =>
    StoryListResponse(
      error: json['error'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      listStory:
          (json['listStory'] as List<dynamic>?)
              ?.map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$StoryListResponseToJson(StoryListResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'listStory': instance.listStory,
    };

StoryDetailResponse _$StoryDetailResponseFromJson(Map<String, dynamic> json) =>
    StoryDetailResponse(
      error: json['error'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      story: json['story'] == null
          ? null
          : StoryModel.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoryDetailResponseToJson(
  StoryDetailResponse instance,
) => <String, dynamic>{
  'error': instance.error,
  'message': instance.message,
  'story': instance.story,
};
