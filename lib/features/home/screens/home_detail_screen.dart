import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base_result_state.dart';
import '../../../shared/model/story.dart';
import '../providers/story_detail/story_detail_provider.dart';

class HomeDetailScreen extends StatefulWidget {
  const HomeDetailScreen({required this.storyId, super.key});

  final String storyId;

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryDetailProvider>().fetchStory(widget.storyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Story Detail')),
      body: Consumer<StoryDetailProvider>(
        builder: (context, detailProvider, _) {
          final detailState = detailProvider.state;

          if (detailState is BaseResultStateLoading ||
              detailState is BaseResultStateInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (detailState is BaseResultStateError<StoryModel>) {
            return Center(child: Text(detailState.errorMessage));
          }

          if (detailState is! BaseResultStateSuccess<StoryModel>) {
            return const SizedBox.shrink();
          }

          final story = detailState.data;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    story.photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const ColoredBox(
                        color: Color(0xFFE0E0E0),
                        child: Icon(Icons.broken_image_outlined, size: 48),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(story.formattedCreatedAt),
                      const SizedBox(height: 16),
                      Text(story.description),
                      if (story.lat != null && story.lon != null) ...[
                        const SizedBox(height: 16),
                        Text('Lat: ${story.lat}'),
                        Text('Lon: ${story.lon}'),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
