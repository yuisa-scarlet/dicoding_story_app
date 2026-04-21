import 'package:flutter_test/flutter_test.dart';
import 'package:lilian_flutter_starter/shared/model/api_response.dart';
import 'package:lilian_flutter_starter/shared/model/story.dart';
import 'package:lilian_flutter_starter/shared/model/user.dart';

void main() {
  group('API model serialization', () {
    test('StoryModel serializes and deserializes correctly', () {
      final now = DateTime.parse('2026-04-21T10:00:00.000Z');
      final story = StoryModel(
        id: 'story-1',
        name: 'Rina',
        description: 'Belajar Flutter',
        photoUrl: 'https://example.com/photo.jpg',
        createdAt: now,
        lat: -6.2,
        lon: 106.8,
      );

      final json = story.toJson();
      final parsed = StoryModel.fromJson(json);

      expect(parsed.id, story.id);
      expect(parsed.name, story.name);
      expect(parsed.description, story.description);
      expect(parsed.photoUrl, story.photoUrl);
      expect(parsed.createdAt.toUtc(), now.toUtc());
      expect(parsed.lat, story.lat);
      expect(parsed.lon, story.lon);
    });

    test('UserSession serializes and deserializes correctly', () {
      const session = UserSession(
        userId: 'u-1',
        name: 'Rina',
        token: 'abc-token',
      );

      final json = session.toJson();
      final parsed = UserSession.fromJson(json);

      expect(parsed.userId, session.userId);
      expect(parsed.name, session.name);
      expect(parsed.token, session.token);
    });

    test('response models deserialize correctly', () {
      final login = LoginResponse.fromJson({
        'error': false,
        'message': 'success',
        'loginResult': {'userId': 'u1', 'name': 'Rina', 'token': 'token-1'},
      });
      final list = StoryListResponse.fromJson({
        'error': false,
        'message': 'ok',
        'listStory': [
          {
            'id': 's1',
            'name': 'Rina',
            'description': 'desc',
            'photoUrl': 'https://example.com/1.jpg',
            'createdAt': '2026-04-21T10:00:00.000Z',
            'lat': -6.2,
            'lon': 106.8,
          },
        ],
      });
      final detail = StoryDetailResponse.fromJson({
        'error': false,
        'message': 'ok',
        'story': {
          'id': 's2',
          'name': 'Budi',
          'description': 'detail',
          'photoUrl': 'https://example.com/2.jpg',
          'createdAt': '2026-04-21T11:00:00.000Z',
        },
      });

      expect(login.error, isFalse);
      expect(login.loginResult?.token, 'token-1');
      expect(list.error, isFalse);
      expect(list.listStory.length, 1);
      expect(detail.story?.id, 's2');
    });
  });
}
