import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/story_list_provider.dart';
import '../widgets/animated_story_card.dart';
import '../../data/repositories/story_repository.dart';
import '../../config/flavor_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<StoryListProvider>();
      provider.loadMoreStories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final flavorConfig = FlavorConfig.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(flavorConfig.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Consumer<StoryListProvider>(
        builder: (context, provider, child) {
          // Only show full page loading if we have no stories
          if (provider.state == StoryListState.loading &&
              provider.stories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == StoryListState.error &&
              provider.stories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 16),
                  Text(provider.errorMessage ?? 'Failed to load stories'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadStories(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.stories.isEmpty) {
            return const Center(child: Text('No stories yet'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: provider.stories.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= provider.stories.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final story = provider.stories[index];
                return AnimatedStoryCard(
                  story: story,
                  index: index,
                  onTap: () {
                    context.push('/story/${story.id}');
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-story');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
