import 'package:flutter_test/flutter_test.dart';
import 'package:lilian_flutter_starter/core/api_client.dart';
import 'package:lilian_flutter_starter/core/app.dart';
import 'package:lilian_flutter_starter/features/auth/providers/auth_provider.dart';
import 'package:lilian_flutter_starter/shared/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets(
    'shows login screen on startup when app is wrapped with providers',
    (WidgetTester tester) async {
      final apiClient = FakeApiClient();
      final authProvider = AuthProvider(apiClient: apiClient);
      final localeProvider = LocaleProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<ApiClient>.value(value: apiClient),
            ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
          ],
          child: const StoryApp(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Sign In'), findsOneWidget);
    },
  );
}
