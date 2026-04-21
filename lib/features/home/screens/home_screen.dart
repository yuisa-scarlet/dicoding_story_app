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
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 240) {
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

          Widget content;

          if (storyState is BaseResultStateLoading ||
              storyState is BaseResultStateInitial) {
            content = const LoadingShimmer();
          } else if (storyState is BaseResultStateError<List<StoryModel>>) {
            content = Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(storyState.errorMessage, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => _loadStories(forceRefresh: true),
                      child: Text(strings.retry),
                    ),
                  ],
                ),
              ),
            );
          } else if (storyState is BaseResultStateSuccess<List<StoryModel>>) {
            final stories = storyState.data;
            if (stories.isEmpty) {
              content = Center(child: Text(strings.noStories));
            } else {
              content = RefreshIndicator(
                onRefresh: () => _loadStories(forceRefresh: true),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      stories.length + (storyProvider.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == stories.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final story = stories[index];
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 220 + (index % 8) * 35),
                      tween: Tween(begin: 0, end: 1),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 12 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: StoryCard(
                        story: story,
                        onTap: () => context
                            .read<NavigationProvider>()
                            .goToStoryDetail(story.id),
                      ),
                    );
                  },
                ),
              );
            }
          } else {
            content = const SizedBox.shrink();
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: KeyedSubtree(
              key: ValueKey(storyState.runtimeType),
              child: content,
            ),
          );
        },
      ),
    );
  }
}
