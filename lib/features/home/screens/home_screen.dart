import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_route.dart';
import '../../../core/base_result_state.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/model/story.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../shared/widgets/story_bottom_navigation.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/story_list/story_list_provider.dart';
import '../widgets/story_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStories());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<StoryListProvider>().fetchMoreStories();
    }
  }

  Future<void> _loadStories({bool forceRefresh = false}) async {
    if (!context.read<AuthProvider>().isLoggedIn) return;

    await context.read<StoryListProvider>().fetchStories(
          forceRefresh: forceRefresh,
        );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appTitle),
        actions: [
          IconButton(
            onPressed: () => context.read<NavigationProvider>().goToAddStory(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: const StoryBottomNavigation(currentIndex: 0),
      body: Consumer<StoryListProvider>(
        builder: (context, storyProvider, _) {
          final storyState = storyProvider.state;

          if (storyState is BaseResultStateLoading ||
              storyState is BaseResultStateInitial) {
            return const LoadingShimmer();
          }

          if (storyState is BaseResultStateError<List<StoryModel>>) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      storyState.errorMessage,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => _loadStories(forceRefresh: true),
                      child: Text(strings.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          if (storyState is! BaseResultStateSuccess<List<StoryModel>>) {
            return const SizedBox.shrink();
          }

          final stories = storyState.data;

          if (stories.isEmpty) {
            return Center(child: Text(strings.noStories));
          }

          return RefreshIndicator(
            onRefresh: () => _loadStories(forceRefresh: true),
            child: Consumer<StoryListProvider>(
              builder: (context, provider, _) {
                return ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: stories.length + (provider.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == stories.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final story = stories[index];
                    return StoryCard(
                      story: story,
                      onTap: () => context
                          .read<NavigationProvider>()
                          .goToStoryDetail(story.id),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
