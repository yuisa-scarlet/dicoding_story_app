import 'package:flutter/widgets.dart';

import 'core/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoryApp();
  }
}
