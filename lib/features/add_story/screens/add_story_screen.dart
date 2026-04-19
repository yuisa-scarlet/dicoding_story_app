import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_route.dart';
import '../../../core/base_result_state.dart';
import '../../../shared/localization/app_strings.dart';
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final addStoryProvider = context.read<AddStoryProvider>();
    await addStoryProvider.submitStory(
      description: _descriptionController.text.trim(),
      latitude: _latitudeController.text.trim(),
      longitude: _longitudeController.text.trim(),
    );

    if (!mounted) return;

    final state = addStoryProvider.state;
    if (state is BaseResultStateSuccess) {
      await context.read<StoryListProvider>().fetchStories(
            forceRefresh: true,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.uploadSuccess)),
      );
      context.read<NavigationProvider>().goToHome();
      return;
    }
    if (state is BaseResultStateError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.addStory)),
      bottomNavigationBar: const StoryBottomNavigation(currentIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Consumer<AddStoryProvider>(
              builder: (context, addStoryProvider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (addStoryProvider.selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(addStoryProvider.selectedImage!.path),
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(Icons.image_outlined, size: 48),
                      ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: addStoryProvider.state is BaseResultStateLoading
                          ? null
                          : () => addStoryProvider.pickImage(),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(strings.selectImage),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          InputDecoration(labelText: strings.description),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return strings.requiredField;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _latitudeController,
                      decoration: InputDecoration(labelText: strings.latitude),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _longitudeController,
                      decoration: InputDecoration(labelText: strings.longitude),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: addStoryProvider.state is BaseResultStateLoading
                          ? null
                          : _submit,
                      icon: addStoryProvider.state is BaseResultStateLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.cloud_upload_outlined),
                      label: Text(strings.uploadStory),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
