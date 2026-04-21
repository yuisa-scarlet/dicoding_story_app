import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base_result_state.dart';
import '../../../core/config.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/theme/app_color.dart';
import '../../../shared/widgets/rounded_text_field.dart';
import '../controllers/add_story_controller.dart';
import '../providers/add_story_provider.dart';
import 'image_picker_area.dart';
import 'location_picker_section.dart';

class AddStoryForm extends StatelessWidget {
  const AddStoryForm({super.key, required this.controller});

  final AddStoryController controller;

  AddStoryController get _c => controller;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Consumer<AddStoryProvider>(
      builder: (context, addStoryProvider, _) {
        final isLoading = addStoryProvider.state is BaseResultStateLoading;

        return Form(
          key: _c.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: AppColor.textDark,
                    padding: EdgeInsets.zero,
                    onPressed: _c.goToHome,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    strings.addStory,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // Image picker
              ImagePickerArea(provider: addStoryProvider, isLoading: isLoading),
              const SizedBox(height: 24),
              // Description
              RoundedTextField(
                controller: _c.descriptionController,
                hint: strings.description,
                icon: Icons.edit_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return strings.requiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (AppConfig.canUseMap) ...[
                LocationPickerSection(isLoading: isLoading),
                const SizedBox(height: 32),
              ],
              // Submit button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _c.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    disabledBackgroundColor: AppColor.disabled,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            key: ValueKey('upload-loading'),
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.cloud_upload_outlined,
                            key: ValueKey('upload-idle'),
                          ),
                  ),
                  label: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      isLoading ? strings.uploading : strings.uploadStory,
                      key: ValueKey(isLoading),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
