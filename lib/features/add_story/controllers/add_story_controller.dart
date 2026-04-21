import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_route.dart';
import '../../../core/base_result_state.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/widgets/app_snack_bar.dart';
import '../../home/providers/story_list/story_list_provider.dart';
import '../providers/add_story_provider.dart';

class AddStoryController {
  AddStoryController({required this.context}) {
    formKey = GlobalKey<FormState>();
    descriptionController = TextEditingController();
  }

  final BuildContext context;

  late final GlobalKey<FormState> formKey;
  late final TextEditingController descriptionController;

  void dispose() {
    descriptionController.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    final addStoryProvider = context.read<AddStoryProvider>();
    final storyListProvider = context.read<StoryListProvider>();
    final navigationProvider = context.read<NavigationProvider>();
    final strings = context.strings;

    if (addStoryProvider.selectedImage == null) {
      AppSnackBar.error(context, strings.choosePhotoFirst);
      return;
    }

    await addStoryProvider.submitStory(
      description: descriptionController.text.trim(),
    );

    if (!context.mounted) return;

    final state = addStoryProvider.state;
    if (state is BaseResultStateSuccess) {
      await storyListProvider.fetchStories(forceRefresh: true);
      if (!context.mounted) return;
      AppSnackBar.success(context, strings.uploadSuccess);
      navigationProvider.goToHome();
      return;
    }
    if (state is BaseResultStateError) {
      AppSnackBar.error(context, state.errorMessage);
    }
  }

  void goToHome() => context.read<NavigationProvider>().goToHome();
}
