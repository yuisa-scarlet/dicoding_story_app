import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_route.dart';
import '../../../core/base_result_state.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/widgets/app_snack_bar.dart';
import '../providers/auth_provider.dart';

class RegisterController {
  RegisterController({required this.context}) {
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  final BuildContext context;

  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final navigationProvider = context.read<NavigationProvider>();
    final strings = context.strings;
    await authProvider.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!context.mounted) return;

    final state = authProvider.registerState;
    if (state is BaseResultStateSuccess<void>) {
      AppSnackBar.success(context, strings.registerSuccess);
      navigationProvider.goToLogin();
      return;
    }
    if (state is BaseResultStateError<void>) {
      AppSnackBar.error(context, state.errorMessage);
    }
  }

  void goToLogin() => context.read<NavigationProvider>().goToLogin();
}
