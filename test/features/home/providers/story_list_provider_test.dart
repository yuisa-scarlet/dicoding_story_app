import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lilian_flutter_starter/core/base_result_state.dart';
import 'package:lilian_flutter_starter/features/home/providers/story_list/story_list_provider.dart';
import 'package:lilian_flutter_starter/shared/model/story.dart';

import '../../../helpers/fake_api_client.dart';

void main() {
  group('StoryListProvider pagination', () {
    test('loads first page and appends next page', () async {
      final apiClient = FakeApiClient(
        onGet: (path) async {
          if (path.contains('page=1')) {
            return _successResponse(page: 1, count: 20);
          }
          if (path.contains('page=2')) {
            return _successResponse(page: 2, count: 5);
          }
          return _successResponse(page: 1, count: 0);
        },
      );
      final provider = StoryListProvider(apiClient: apiClient);

      await provider.fetchStories();
      expect(provider.state, isA<BaseResultStateSuccess<List<StoryModel>>>());
      expect(
        (provider.state as BaseResultStateSuccess<List<StoryModel>>)
            .data
            .length,
        20,
      );
      expect(provider.hasMore, isTrue);

      await provider.fetchMoreStories();
      expect(
        (provider.state as BaseResultStateSuccess<List<StoryModel>>)
            .data
            .length,
        25,
      );
      expect(provider.hasMore, isFalse);
    });

    test(
      'does not issue duplicate fetchMore while a fetch is ongoing',
      () async {
        final page2Completer = Completer<http.Response>();
        var page2CallCount = 0;

        final apiClient = FakeApiClient(
          onGet: (path) async {
            if (path.contains('page=1')) {
              return _successResponse(page: 1, count: 20);
            }
            if (path.contains('page=2')) {
              page2CallCount++;
              return page2Completer.future;
            }
            return _successResponse(page: 1, count: 0);
          },
        );
        final provider = StoryListProvider(apiClient: apiClient);

        await provider.fetchStories();

        final f1 = provider.fetchMoreStories();
        final f2 = provider.fetchMoreStories();
        expect(page2CallCount, 1);

        page2Completer.complete(_successResponse(page: 2, count: 20));
        await Future.wait([f1, f2]);
        expect(page2CallCount, 1);
        expect(provider.isLoadingMore, isFalse);
      },
    );

    test('keeps previous data when load-more fails', () async {
      final apiClient = FakeApiClient(
        onGet: (path) async {
          if (path.contains('page=1')) {
            return _successResponse(page: 1, count: 20);
          }
          if (path.contains('page=2')) {
            return _errorResponse();
          }
          return _successResponse(page: 1, count: 0);
        },
      );
      final provider = StoryListProvider(apiClient: apiClient);

      await provider.fetchStories();
      await provider.fetchMoreStories();

      expect(provider.state, isA<BaseResultStateSuccess<List<StoryModel>>>());
      expect(
        (provider.state as BaseResultStateSuccess<List<StoryModel>>)
            .data
            .length,
        20,
      );
      expect(provider.isLoadingMore, isFalse);
    });
  });
}

http.Response _successResponse({required int page, required int count}) {
  final storyBaseIndex = ((page - 1) * 1000);
  final listStory = List.generate(count, (index) {
    final id = storyBaseIndex + index + 1;
    return {
      'id': 'story-$id',
      'name': 'User $id',
      'description': 'Desc $id',
      'photoUrl': 'https://example.com/$id.jpg',
      'createdAt': '2026-04-21T10:00:00.000Z',
      'lat': -6.2,
      'lon': 106.8,
    };
  });

  return http.Response(
    jsonEncode({
      'error': false,
      'message': 'Stories fetched successfully',
      'listStory': listStory,
    }),
    200,
  );
}

http.Response _errorResponse() {
  return http.Response(
    jsonEncode({
      'error': true,
      'message': 'Something went wrong',
      'listStory': [],
    }),
    500,
  );
}
