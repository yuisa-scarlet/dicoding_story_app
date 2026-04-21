enum AppFlavor { free, paid }

extension AppFlavorX on AppFlavor {
  static AppFlavor fromName(String value) {
    switch (value.toLowerCase()) {
      case 'free':
        return AppFlavor.free;
      case 'paid':
      default:
        return AppFlavor.paid;
    }
  }
}

class AppConfig {
  static const String appName = 'Story App';
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';
  static const Duration requestTimeout = Duration(seconds: 20);
  static const int pageSize = 20;
  static const bool isTest = bool.fromEnvironment('FLUTTER_TEST');

  static AppFlavor _flavor = AppFlavor.paid;

  static AppFlavor get flavor => _flavor;
  static bool get canUseMap => _flavor == AppFlavor.paid;
  static String get flavorName => _flavor.name;

  static void initializeFlavor(AppFlavor flavor) {
    _flavor = flavor;
  }
}
