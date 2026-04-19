import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_provider.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../shared/widgets/story_bottom_navigation.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.settings)),
      bottomNavigationBar: const StoryBottomNavigation(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            strings.language,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, _) {
              final currentLanguage = localeProvider.locale.languageCode;

              Widget buildLanguageTile(String code, String label) {
                return ListTile(
                  leading: Icon(
                    currentLanguage == code
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                  ),
                  title: Text(label),
                  onTap: () => localeProvider.setLocale(Locale(code)),
                );
              }

              return Column(
                children: [
                  buildLanguageTile('en', strings.english),
                  buildLanguageTile('id', strings.indonesian),
                  buildLanguageTile('ja', strings.japanese),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notification integration ready'),
              subtitle: const Text(
                'Subscribe and unsubscribe hooks can be connected to the provided API next.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return FilledButton.icon(
                onPressed: () async {
                  await authProvider.logout();
                  // Navigation to login is handled automatically by AppRouterDelegate
                },
                icon: const Icon(Icons.logout),
                label: Text(strings.logout),
              );
            },
          ),
        ],
      ),
    );
  }
}
