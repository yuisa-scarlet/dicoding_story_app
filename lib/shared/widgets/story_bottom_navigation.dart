import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_route.dart';
import '../localization/app_strings.dart';
import '../theme/app_color.dart';

class StoryBottomNavigation extends StatelessWidget {
  const StoryBottomNavigation({required this.currentIndex, super.key});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final nav = context.read<NavigationProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
        child: SizedBox(
          height: 64,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Pill background
              Container(
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Home
                    Expanded(
                      child: _NavItem(
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home_rounded,
                        label: strings.home,
                        isActive: currentIndex == 0,
                        onTap: nav.goToHome,
                      ),
                    ),
                    // Spacer for center button
                    const Expanded(child: SizedBox()),
                    // Settings
                    Expanded(
                      child: _NavItem(
                        icon: Icons.settings_outlined,
                        activeIcon: Icons.settings_rounded,
                        label: strings.settings,
                        isActive: currentIndex == 2,
                        onTap: nav.goToSettings,
                      ),
                    ),
                  ],
                ),
              ),
              // Center FAB
              Positioned(
                top: -16,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: nav.goToAddStory,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.primary.withAlpha(80),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColor.primary : AppColor.disabled;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isActive ? activeIcon : icon, color: color, size: 24),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
