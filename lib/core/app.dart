import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../features/add_story/providers/add_story_provider.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/home/providers/story_detail/story_detail_provider.dart';
import '../features/home/providers/story_list/story_list_provider.dart';
import '../shared/localization/app_strings.dart';
import '../shared/providers/locale_provider.dart';
import '../shared/theme/app_color.dart';
import 'api_client.dart';
import 'app_route.dart';
import 'config.dart';

class StoryApp extends StatefulWidget {
  const StoryApp({super.key});

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late final NavigationProvider _navigationProvider;
  late final StoryListProvider _storyListProvider;
  late final StoryDetailProvider _storyDetailProvider;
  late final AddStoryProvider _addStoryProvider;
  late final AppRouterDelegate _routerDelegate;
  late final AppRouteInformationParser _routeInformationParser;
  bool _ready = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    _ready = true;

    final apiClient = context.read<ApiClient>();
    final authProvider = context.read<AuthProvider>();

    _navigationProvider = NavigationProvider();
    _storyListProvider = StoryListProvider(apiClient: apiClient);
    _storyDetailProvider = StoryDetailProvider(apiClient: apiClient);
    _addStoryProvider = AddStoryProvider(apiClient: apiClient);
    _routerDelegate = AppRouterDelegate(
      authProvider: authProvider,
      navigationProvider: _navigationProvider,
    );
    _routeInformationParser = AppRouteInformationParser();
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
      useMaterial3: true,
      fontFamily: 'PlusJakartaSans',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationProvider>.value(
          value: _navigationProvider,
        ),
        ChangeNotifierProvider<StoryListProvider>.value(
          value: _storyListProvider,
        ),
        ChangeNotifierProvider<StoryDetailProvider>.value(
          value: _storyDetailProvider,
        ),
        ChangeNotifierProvider<AddStoryProvider>.value(
          value: _addStoryProvider,
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp.router(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(),
            locale: localeProvider.locale,
            supportedLocales: AppStrings.supportedLocales,
            localizationsDelegates: const [
              AppStrings.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeInformationParser,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _routerDelegate.dispose();
    super.dispose();
  }
}
