import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_route.dart';
import '../../../core/base_result_state.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/theme/app_color.dart';
import '../../../shared/widgets/app_snack_bar.dart';
import '../../../shared/widgets/rounded_text_field.dart';
import '../../../shared/widgets/story_bottom_navigation.dart';
import '../../home/providers/story_list/story_list_provider.dart';
import '../providers/add_story_provider.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final addStoryProvider = context.read<AddStoryProvider>();

    if (addStoryProvider.selectedImage == null) {
      AppSnackBar.error(context, context.strings.choosePhotoFirst);
      return;
    }

    await addStoryProvider.submitStory(
      description: _descriptionController.text.trim(),
      latitude: _latitudeController.text.trim(),
      longitude: _longitudeController.text.trim(),
    );

    if (!mounted) return;

    final state = addStoryProvider.state;
    if (state is BaseResultStateSuccess) {
      await context.read<StoryListProvider>().fetchStories(forceRefresh: true);
      if (!mounted) return;
      AppSnackBar.success(context, context.strings.uploadSuccess);
      context.read<NavigationProvider>().goToHome();
      return;
    }
    if (state is BaseResultStateError) {
      AppSnackBar.error(context, state.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const StoryBottomNavigation(currentIndex: 1),
      body: SafeArea(
        child: Consumer<AddStoryProvider>(
          builder: (context, addStoryProvider, _) {
            final isLoading =
                addStoryProvider.state is BaseResultStateLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
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
                          onPressed: () => context
                              .read<NavigationProvider>()
                              .goToHome(),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          strings.addStory,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColor.textDark,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Image picker area
                    GestureDetector(
                      onTap: isLoading ? null : addStoryProvider.pickImage,
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: addStoryProvider.selectedImage != null
                                ? AppColor.primary
                                : AppColor.borderLight,
                            width: addStoryProvider.selectedImage != null
                                ? 2
                                : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: addStoryProvider.selectedImage != null
                            ? Image.file(
                                File(addStoryProvider.selectedImage!.path),
                                fit: BoxFit.cover,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColor.primary.withAlpha(25),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: AppColor.primary,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    strings.selectImage,
                                    style: const TextStyle(
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'JPG, PNG supported',
                                    style: TextStyle(
                                      color: AppColor.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    if (addStoryProvider.selectedImage != null) ...[
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton.icon(
                          onPressed: isLoading
                              ? null
                              : addStoryProvider.pickImage,
                          icon: const Icon(
                            Icons.swap_horiz_rounded,
                            size: 18,
                            color: AppColor.primary,
                          ),
                          label: Text(
                            strings.selectImage,
                            style: const TextStyle(
                              color: AppColor.primary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Description
                    RoundedTextField(
                      controller: _descriptionController,
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
                    // Location row
                    Row(
                      children: [
                        Expanded(
                          child: RoundedTextField(
                            controller: _latitudeController,
                            hint: strings.latitude,
                            icon: Icons.location_on_outlined,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RoundedTextField(
                            controller: _longitudeController,
                            hint: strings.longitude,
                            icon: Icons.explore_outlined,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
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
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    strings.uploadStory,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
