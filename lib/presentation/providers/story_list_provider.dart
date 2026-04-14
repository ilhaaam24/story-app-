import 'package:flutter/foundation.dart';
import '../../data/models/story_model.dart';
import '../../data/repositories/story_repository.dart';

enum StoryListState { initial, loading, loaded, loadingMore, error }

class StoryListProvider extends ChangeNotifier {
  final StoryRepository _storyRepository;
  final String token;

  StoryListProvider(this._storyRepository, this.token) {
    loadStories();
  }

  StoryListState _state = StoryListState.initial;
  List<StoryModel> _stories = [];
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;
  final int _pageSize = 10;

  StoryListState get state => _state;
  List<StoryModel> get stories => _stories;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  // Load initial stories
  Future<void> loadStories({bool isRefresh = false}) async {
    if (!isRefresh) {
      _state = StoryListState.loading;
      _stories.clear();
      notifyListeners();
    }

    _currentPage = 1;

    try {
      final response = await _storyRepository.getStories(
        token: token,
        page: _currentPage,
        size: _pageSize,
      );

      _stories = response.listStory.toList();
      _hasMore = response.listStory.length >= _pageSize;
      _state = StoryListState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = StoryListState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // Load more stories (pagination)
  Future<void> loadMoreStories() async {
    if (!_hasMore || _state == StoryListState.loadingMore) return;

    _state = StoryListState.loadingMore;
    notifyListeners();

    try {
      _currentPage++;
      final response = await _storyRepository.getStories(
        token: token,
        page: _currentPage,
        size: _pageSize,
      );

      _stories.addAll(response.listStory);
      _hasMore = response.listStory.length >= _pageSize;
      _state = StoryListState.loaded;
    } catch (e) {
      _currentPage--;
      _errorMessage = e.toString();
      _state = StoryListState.error;
    }
    notifyListeners();
  }

  // Refresh stories
  Future<void> refresh() async {
    await loadStories(isRefresh: true);
  }
}
