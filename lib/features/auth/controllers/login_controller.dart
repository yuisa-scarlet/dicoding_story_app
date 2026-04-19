import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_route.dart';
import '../../../core/base_result_state.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/model/user.dart';
import '../../../shared/widgets/app_snack_bar.dart';
import '../providers/auth_provider.dart';

class LoginController {
  LoginController({
    required this.context,
    required this.isMounted,
  }) {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  final BuildContext context;
  final bool Function() isMounted;

  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!isMounted()) return;

    final state = authProvider.loginState;
    if (state is BaseResultStateSuccess<UserSession>) {
      AppSnackBar.success(context, context.strings.loginSuccess);
    } else if (state is BaseResultStateError<UserSession>) {
      AppSnackBar.error(context, state.errorMessage);
    }
    // Navigation to home is handled automatically by AppRouterDelegate
  }

  void goToRegister() =>
      context.read<NavigationProvider>().goToRegister();
}
