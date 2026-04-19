import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_route.dart';
import '../../../core/base_result_state.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/widgets/app_snack_bar.dart';
import '../../home/providers/story_list/story_list_provider.dart';
import '../providers/add_story_provider.dart';

class AddStoryController {
  AddStoryController({
    required this.context,
    required this.isMounted,
  }) {
    formKey = GlobalKey<FormState>();
    descriptionController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
  }

  final BuildContext context;
  final bool Function() isMounted;

  late final GlobalKey<FormState> formKey;
  late final TextEditingController descriptionController;
  late final TextEditingController latitudeController;
  late final TextEditingController longitudeController;

  void dispose() {
    descriptionController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    final addStoryProvider = context.read<AddStoryProvider>();

    if (addStoryProvider.selectedImage == null) {
      AppSnackBar.error(context, context.strings.choosePhotoFirst);
      return;
    }

    await addStoryProvider.submitStory(
      description: descriptionController.text.trim(),
      latitude: latitudeController.text.trim(),
      longitude: longitudeController.text.trim(),
    );

    if (!isMounted()) return;

    final state = addStoryProvider.state;
    if (state is BaseResultStateSuccess) {
      await context.read<StoryListProvider>().fetchStories(forceRefresh: true);
      if (!isMounted()) return;
      AppSnackBar.success(context, context.strings.uploadSuccess);
      context.read<NavigationProvider>().goToHome();
      return;
    }
    if (state is BaseResultStateError) {
      AppSnackBar.error(context, state.errorMessage);
    }
  }

  void goToHome() => context.read<NavigationProvider>().goToHome();
}
