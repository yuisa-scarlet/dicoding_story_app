import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../../core/api_client.dart';
import '../../../../core/base_result_state.dart';
import '../../../../core/config.dart';
import '../../../../shared/model/api_response.dart';
import '../../../../shared/model/story.dart';

class StoryDetailProvider extends ChangeNotifier {
  StoryDetailProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  BaseResultState<StoryModel> _state =
      const BaseResultStateInitial<StoryModel>();

  BaseResultState<StoryModel> get state => _state;

  Future<void> fetchStory(String id) async {
    _state = const BaseResultStateLoading<StoryModel>();
    notifyListeners();

    try {
      final response = await _apiClient
          .get('/stories/$id')
          .timeout(AppConfig.requestTimeout);

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final apiResponse = StoryDetailResponse.fromJson(decoded);
      if (response.statusCode >= 400 || apiResponse.error) {
        throw Exception(
          apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Failed to load story',
        );
      }

      final story = apiResponse.story;
      if (story == null) {
        throw Exception('Story not found');
      }

      _state = BaseResultStateSuccess<StoryModel>(story);
    } on SocketException {
      _state = const BaseResultStateError<StoryModel>('No internet connection');
    } catch (e) {
      _state = BaseResultStateError<StoryModel>(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }

    notifyListeners();
  }
}
