import 'package:flutter/material.dart';

import 'core/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5)),
      useMaterial3: true,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: 'PlusJakartaSans',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const StoryApp();
  }
}
