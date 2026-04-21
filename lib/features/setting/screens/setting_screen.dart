import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_provider.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../shared/theme/app_color.dart';
import '../../../shared/widgets/app_snack_bar.dart';
import '../../../shared/widgets/story_bottom_navigation.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          strings.settings,
          style: const TextStyle(
            color: AppColor.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: const StoryBottomNavigation(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        children: [
          Text(
            strings.language,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColor.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, _) {
              final currentLanguage = localeProvider.locale.languageCode;

              Widget buildLanguageTile(String code, String label) {
                final isActive = currentLanguage == code;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    isActive
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isActive ? AppColor.primary : AppColor.disabled,
                  ),
                  title: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? AppColor.primary : AppColor.textBody,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
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
          const SizedBox(height: 16),
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await authProvider.logout();
                    if (context.mounted) {
                      AppSnackBar.success(
                        context,
                        AppStrings.of(context).logoutSuccess,
                      );
                    }
                    // Navigation to login is handled automatically by AppRouterDelegate
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(
                    strings.logout,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.error,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
