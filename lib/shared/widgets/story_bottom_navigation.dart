import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_route.dart';
import '../localization/app_strings.dart';

class StoryBottomNavigation extends StatelessWidget {
  const StoryBottomNavigation({
    required this.currentIndex,
    super.key,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        final nav = context.read<NavigationProvider>();
        switch (index) {
          case 0:
            nav.goToHome();
          case 1:
            nav.goToAddStory();
          case 2:
            nav.goToSettings();
        }
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: strings.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.add_a_photo_outlined),
          selectedIcon: const Icon(Icons.add_a_photo),
          label: strings.addStory,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: strings.settings,
        ),
      ],
    );
  }
}
