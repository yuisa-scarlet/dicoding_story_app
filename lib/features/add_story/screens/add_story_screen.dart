import 'package:flutter/material.dart';

import '../../../shared/widgets/story_bottom_navigation.dart';
import '../controllers/add_story_controller.dart';
import '../widgets/add_story_form.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  late final AddStoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddStoryController(context: context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const StoryBottomNavigation(currentIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: AddStoryForm(controller: _controller),
        ),
      ),
    );
  }
}
