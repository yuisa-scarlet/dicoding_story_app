import 'core/bootstrap.dart';
import 'core/config.dart';

Future<void> main() async {
  const flavorName = String.fromEnvironment('APP_FLAVOR', defaultValue: 'paid');

  await bootstrap(AppFlavorX.fromName(flavorName));
}
