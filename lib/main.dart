import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/api_client.dart';
import 'core/app.dart';
import 'core/config.dart';
import 'features/auth/providers/auth_provider.dart';
import 'shared/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient(baseUrl: AppConfig.baseUrl);
  final authProvider = AuthProvider(apiClient: apiClient);
  final localeProvider = LocaleProvider();

  await _initializeApp(authProvider, localeProvider);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
      ],
      child: const StoryApp(),
    ),
  );
}

Future<void> _initializeApp(
  AuthProvider authProvider,
  LocaleProvider localeProvider,
) async {
  try {
    await Future.wait([
      authProvider.restoreSession(),
      localeProvider.loadLocale(),
    ]);
  } catch (e) {
    debugPrint('App initialization error: $e');
  }
}

