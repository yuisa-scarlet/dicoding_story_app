import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../features/add_story/providers/add_story_provider.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/home/providers/story_detail/story_detail_provider.dart';
import '../features/home/providers/story_list/story_list_provider.dart';
import '../shared/localization/app_strings.dart';
import '../shared/providers/locale_provider.dart';
import 'api_client.dart';
import 'app_route.dart';
import 'config.dart';

class StoryApp extends StatefulWidget {
  const StoryApp({super.key});

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late final ApiClient _apiClient;
  late final AuthProvider _authProvider;
  late final LocaleProvider _localeProvider;
  late final StoryListProvider _storyListProvider;
  late final StoryDetailProvider _storyDetailProvider;
  late final AddStoryProvider _addStoryProvider;
  late final NavigationProvider _navigationProvider;
  late final AppRouterDelegate _routerDelegate;
  late final AppRouteInformationParser _routeInformationParser;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(baseUrl: AppConfig.baseUrl);
    _authProvider = AuthProvider(apiClient: _apiClient);
    _localeProvider = LocaleProvider();
    _storyListProvider = StoryListProvider(apiClient: _apiClient);
    _storyDetailProvider = StoryDetailProvider(apiClient: _apiClient);
    _addStoryProvider = AddStoryProvider(apiClient: _apiClient);
    _navigationProvider = NavigationProvider();
    _routerDelegate = AppRouterDelegate(
      authProvider: _authProvider,
      navigationProvider: _navigationProvider,
    );
    _routeInformationParser = AppRouteInformationParser();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      _authProvider.restoreSession(),
      _localeProvider.loadLocale(),
    ]);

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConfig.appName,
        home: const _SplashScreen(),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: _authProvider),
        ChangeNotifierProvider<LocaleProvider>.value(value: _localeProvider),
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
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
            ),
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

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

