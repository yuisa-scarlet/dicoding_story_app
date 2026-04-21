import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilian_flutter_starter/core/app_route.dart';
import 'package:lilian_flutter_starter/core/config.dart';
import 'package:lilian_flutter_starter/features/add_story/providers/add_story_provider.dart';
import 'package:lilian_flutter_starter/features/add_story/screens/add_story_screen.dart';
import 'package:lilian_flutter_starter/features/home/providers/story_list/story_list_provider.dart';
import 'package:lilian_flutter_starter/shared/localization/app_strings.dart';
import 'package:provider/provider.dart';

import '../../helpers/fake_api_client.dart';

void main() {
  testWidgets('free flavor hides map picker section', (tester) async {
    AppConfig.initializeFlavor(AppFlavor.free);

    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Pick Location (Paid)'), findsNothing);
  });

  testWidgets('paid flavor shows map picker section', (tester) async {
    AppConfig.initializeFlavor(AppFlavor.paid);

    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Pick Location (Paid)'), findsOneWidget);
  });
}

Widget _buildTestApp() {
  final apiClient = FakeApiClient();
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<NavigationProvider>(
        create: (_) => NavigationProvider(),
      ),
      ChangeNotifierProvider<AddStoryProvider>(
        create: (_) => AddStoryProvider(apiClient: apiClient),
      ),
      ChangeNotifierProvider<StoryListProvider>(
        create: (_) => StoryListProvider(apiClient: apiClient),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: const [
        AppStrings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AddStoryScreen(),
    ),
  );
}
