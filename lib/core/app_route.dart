import 'package:flutter/material.dart';

import '../features/add_story/screens/add_story_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/home/screens/home_detail_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/setting/screens/setting_screen.dart';

// ---------------------------------------------------------------------------
// Route path model
// ---------------------------------------------------------------------------

enum AppPage { login, register, home, storyDetail, addStory, settings }

class AppRoutePath {
  const AppRoutePath({required this.page, this.storyId});

  final AppPage page;
  final String? storyId;

  static const AppRoutePath login = AppRoutePath(page: AppPage.login);
  static const AppRoutePath register = AppRoutePath(page: AppPage.register);
  static const AppRoutePath home = AppRoutePath(page: AppPage.home);
  static const AppRoutePath addStory = AppRoutePath(page: AppPage.addStory);
  static const AppRoutePath settings = AppRoutePath(page: AppPage.settings);

  static AppRoutePath detail(String id) =>
      AppRoutePath(page: AppPage.storyDetail, storyId: id);
}

// ---------------------------------------------------------------------------
// Navigation state provider
// ---------------------------------------------------------------------------

class NavigationProvider extends ChangeNotifier {
  final List<AppRoutePath> _stack = [AppRoutePath.login];

  List<AppRoutePath> get stack => List.unmodifiable(_stack);
  AppRoutePath get current => _stack.last;

  void goToLogin() {
    _stack
      ..clear()
      ..add(AppRoutePath.login);
    notifyListeners();
  }

  void goToRegister() {
    _stack
      ..clear()
      ..add(AppRoutePath.login)
      ..add(AppRoutePath.register);
    notifyListeners();
  }

  void goToHome() {
    _stack
      ..clear()
      ..add(AppRoutePath.home);
    notifyListeners();
  }

  void goToStoryDetail(String storyId) {
    _stack.removeWhere(
      (r) =>
          r.page == AppPage.storyDetail ||
          r.page == AppPage.addStory ||
          r.page == AppPage.settings,
    );
    if (_stack.isEmpty || _stack.last.page != AppPage.home) {
      _stack.add(AppRoutePath.home);
    }
    _stack.add(AppRoutePath.detail(storyId));
    notifyListeners();
  }

  void goToAddStory() {
    _stack
      ..clear()
      ..add(AppRoutePath.home)
      ..add(AppRoutePath.addStory);
    notifyListeners();
  }

  void goToSettings() {
    _stack
      ..clear()
      ..add(AppRoutePath.home)
      ..add(AppRoutePath.settings);
    notifyListeners();
  }

  bool pop() {
    if (_stack.length > 1) {
      _stack.removeLast();
      notifyListeners();
      return true;
    }
    return false;
  }
}

// ---------------------------------------------------------------------------
// Router delegate
// ---------------------------------------------------------------------------

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AppRouterDelegate({
    required AuthProvider authProvider,
    required NavigationProvider navigationProvider,
  })  : _authProvider = authProvider,
        _navigationProvider = navigationProvider,
        _wasLoggedIn = authProvider.isLoggedIn {
    _authProvider.addListener(_onAuthChanged);
    _navigationProvider.addListener(notifyListeners);
  }

  final AuthProvider _authProvider;
  final NavigationProvider _navigationProvider;

  bool _wasLoggedIn = false;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void _onAuthChanged() {
    final isLoggedIn = _authProvider.isLoggedIn;

    if (isLoggedIn && !_wasLoggedIn) {
      final page = _navigationProvider.current.page;
      if (page == AppPage.login || page == AppPage.register) {
        _navigationProvider.goToHome();
      }
    } else if (!isLoggedIn && _wasLoggedIn) {
      _navigationProvider.goToLogin();
    }

    _wasLoggedIn = isLoggedIn;
    notifyListeners();
  }

  @override
  AppRoutePath get currentConfiguration => _navigationProvider.current;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _buildPages(),
      onDidRemovePage: (page) => _navigationProvider.pop(),
    );
  }

  List<Page<dynamic>> _buildPages() {
    final isLoggedIn = _authProvider.isLoggedIn;
    final pages = <Page<dynamic>>[];

    for (final route in _navigationProvider.stack) {
      final isAuthPage =
          route.page == AppPage.login || route.page == AppPage.register;

      if (!isLoggedIn && !isAuthPage) continue;
      if (isLoggedIn && isAuthPage) continue;

      switch (route.page) {
        case AppPage.login:
          pages.add(
            const MaterialPage(key: ValueKey('login'), child: LoginScreen()),
          );
        case AppPage.register:
          pages.add(
            const MaterialPage(
              key: ValueKey('register'),
              child: RegisterScreen(),
            ),
          );
        case AppPage.home:
          pages.add(
            const MaterialPage(key: ValueKey('home'), child: HomeScreen()),
          );
        case AppPage.storyDetail:
          pages.add(
            MaterialPage(
              key: ValueKey('detail-${route.storyId}'),
              child: HomeDetailScreen(storyId: route.storyId ?? ''),
            ),
          );
        case AppPage.addStory:
          pages.add(
            const MaterialPage(
              key: ValueKey('addStory'),
              child: AddStoryScreen(),
            ),
          );
        case AppPage.settings:
          pages.add(
            const MaterialPage(
              key: ValueKey('settings'),
              child: SettingScreen(),
            ),
          );
      }
    }

    if (pages.isEmpty) {
      pages.add(
        isLoggedIn
            ? const MaterialPage(key: ValueKey('home'), child: HomeScreen())
            : const MaterialPage(
                key: ValueKey('login'),
                child: LoginScreen(),
              ),
      );
    }

    return pages;
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {}

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    _navigationProvider.removeListener(notifyListeners);
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Route information parser
// ---------------------------------------------------------------------------

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) return AppRoutePath.home;

    switch (uri.pathSegments.first) {
      case 'login':
        return AppRoutePath.login;
      case 'register':
        return AppRoutePath.register;
      case 'settings':
        return AppRoutePath.settings;
      case 'stories':
        if (uri.pathSegments.length == 2) {
          if (uri.pathSegments[1] == 'add') return AppRoutePath.addStory;
          return AppRoutePath.detail(uri.pathSegments[1]);
        }
        return AppRoutePath.home;
      default:
        return AppRoutePath.home;
    }
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    switch (configuration.page) {
      case AppPage.login:
        return RouteInformation(uri: Uri.parse('/login'));
      case AppPage.register:
        return RouteInformation(uri: Uri.parse('/register'));
      case AppPage.home:
        return RouteInformation(uri: Uri.parse('/stories'));
      case AppPage.storyDetail:
        return RouteInformation(
          uri: Uri.parse('/stories/${configuration.storyId}'),
        );
      case AppPage.addStory:
        return RouteInformation(uri: Uri.parse('/stories/add'));
      case AppPage.settings:
        return RouteInformation(uri: Uri.parse('/settings'));
    }
  }
}
