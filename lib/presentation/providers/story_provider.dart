import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:submission_pertama/data/models/story_model.dart';
import 'package:submission_pertama/data/repositories/story_repository.dart';

enum StoryState { initial, loading, loaded, error, uploading, uploaded }

class StoryProvider extends ChangeNotifier {
  final StoryRepository _storyRepository;

  StoryState _state = StoryState.initial;
  List<StoryModel> _stories = [];
  String? _errorMessage;

  StoryState get state => _state;
  List<StoryModel> get stories => _stories;
  String? get errorMessage => _errorMessage;

  StoryProvider(this._storyRepository);

  Future<void> fetchStories(String token) async {
    _state = StoryState.loading;
    notifyListeners();

    try {
      final response = await _storyRepository.getStories(token: token);
      _stories = response.listStory;
      _state = StoryState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = StoryState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> uploadStory({
    required String token,
    required String description,
    required File imageFile,
    double? lat,
    double? lon,
  }) async {
    _state = StoryState.uploading;
    notifyListeners();

    try {
      await _storyRepository.addStory(
        token: token,
        description: description,
        imageFile: imageFile,
        lat: lat,
        lon: lon,
      );
      _state = StoryState.uploaded;
      await fetchStories(token); // Refresh after upload
      return true;
    } catch (e) {
      _state = StoryState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
