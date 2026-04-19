import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base_result_state.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/theme/app_color.dart';
import '../../../shared/widgets/rounded_text_field.dart';
import '../controllers/register_controller.dart';
import '../providers/auth_provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, required this.controller});

  final RegisterController controller;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _obscurePassword = true;

  RegisterController get _c => widget.controller;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Form(
      key: _c.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColor.textDark,
            onPressed: _c.goToLogin,
          ),
          const SizedBox(height: 24),
          Text(
            strings.createAccount,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.textDark,
                  height: 1.2,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            strings.registerSubtitle,
            style: const TextStyle(
              color: AppColor.textMuted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 40),
          RoundedTextField(
            controller: _c.nameController,
            hint: strings.fullName,
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return strings.requiredField;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          RoundedTextField(
            controller: _c.emailController,
            hint: strings.email,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return strings.requiredField;
              }
              if (!value.contains('@')) return strings.invalidEmail;
              return null;
            },
          ),
          const SizedBox(height: 16),
          RoundedTextField(
            controller: _c.passwordController,
            hint: strings.password,
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColor.disabled,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return strings.requiredField;
              if (value.length < 8) return strings.passwordTooShort;
              return null;
            },
          ),
          const SizedBox(height: 32),
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              final isLoading =
                  authProvider.registerState is BaseResultStateLoading;
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _c.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    disabledBackgroundColor: AppColor.disabled,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          strings.register,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                strings.haveAccount,
                style: const TextStyle(
                  color: AppColor.textMuted,
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: _c.goToLogin,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  strings.login,
                  style: const TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
