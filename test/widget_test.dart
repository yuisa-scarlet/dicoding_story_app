// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:lilian_flutter_starter/core/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets('shows Story App login screen on startup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const StoryApp());
    await tester.pumpAndSettle();

    expect(find.text('Story App'), findsWidgets);
    expect(find.text('Login'), findsOneWidget);
  });
}
