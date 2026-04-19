import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../../core/api_client.dart';
import '../../../../core/base_result_state.dart';
import '../../../../core/config.dart';
import '../../../../shared/model/story.dart';

class StoryListProvider extends ChangeNotifier {
  StoryListProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  BaseResultState<List<StoryModel>> _state =
      const BaseResultStateInitial<List<StoryModel>>();
  List<StoryModel> _stories = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  BaseResultState<List<StoryModel>> get state => _state;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> fetchStories({
    bool forceRefresh = false,
    int page = 1,
  }) async {
    if (_state is BaseResultStateLoading && !forceRefresh) return;

    _state = const BaseResultStateLoading<List<StoryModel>>();
    _stories = [];
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    try {
      final fetched = await _fetchPage(1);
      _stories = fetched;
      _currentPage = 1;
      _hasMore = fetched.length >= AppConfig.pageSize;
      _state = BaseResultStateSuccess<List<StoryModel>>(List.unmodifiable(_stories));
    } on SocketException {
      _state = const BaseResultStateError<List<StoryModel>>(
        'No internet connection',
      );
    } catch (e) {
      _state = BaseResultStateError<List<StoryModel>>(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }

    notifyListeners();
  }

  Future<void> fetchMoreStories() async {
    if (_isLoadingMore || !_hasMore) return;
    if (_state is! BaseResultStateSuccess) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final fetched = await _fetchPage(nextPage);
      _stories = [..._stories, ...fetched];
      _currentPage = nextPage;
      _hasMore = fetched.length >= AppConfig.pageSize;
      _state = BaseResultStateSuccess<List<StoryModel>>(List.unmodifiable(_stories));
    } on SocketException {
      // keep existing list, silently fail — user can scroll up and back to retry
    } catch (_) {
      // same
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<List<StoryModel>> _fetchPage(int page) async {
    final response = await _apiClient
        .get('/stories?page=$page&size=${AppConfig.pageSize}')
        .timeout(AppConfig.requestTimeout);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400 || decoded['error'] == true) {
      throw Exception(decoded['message'] ?? 'Failed to load stories');
    }

    return (decoded['listStory'] as List<dynamic>? ?? [])
        .map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

