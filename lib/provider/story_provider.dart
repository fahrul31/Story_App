import 'package:flutter/material.dart';
import 'package:story_app/api/api_service.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/model/detail_story.dart';
import 'package:story_app/model/detail_story_result.dart';
import 'package:story_app/provider/auth_provider.dart';

enum ResultState { loading, noData, hasData, error }

class StoryProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;
  final AuthProvider authProvider;
  StoryProvider({
    required this.authProvider,
    required this.authRepository,
    required this.apiService,
  }) {
    _init();
  }

  Future<void> _init() async {
    fetchStories();
  }

  List<Story> _storyResult = [];
  late ResultState _state;
  String _message = '';
  int _location = 0;

  List<Story> get storyResult => _storyResult;
  ResultState get state => _state;
  String get message => _message;
  int get location => _location;

  int? page = 1;
  int size = 10;

  void allStories() {
    _storyResult = [];
    page = 1;
    fetchStories();
  }

  Future<void> fetchStories() async {
    if (page == 1) {
      _state = ResultState.loading;
      notifyListeners();
    }

    final user = await authRepository.getUser();

    if (user != null) {
      final story = await apiService.listStory(
        user.token,
        page!,
        size,
      );
      if (story.listStory.length < size) {
        page = null;
      } else {
        page = page! + 1;
      }

      if (story.listStory.isEmpty) {
        _state = ResultState.noData;
        _message = "Empty Data";
        notifyListeners();
      } else {
        _storyResult.addAll(story.listStory);
        _state = ResultState.hasData;
        notifyListeners();
      }

      if (story.error) {
        _state = ResultState.error;
        _message = story.message;
        notifyListeners();
      }
    }
  }
}

class DetailStoryProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;
  final String id;

  DetailStoryProvider(
      {required this.authRepository,
      required this.apiService,
      required this.id}) {
    _fetchDetailStory(id);
  }

  late DetailStoryResult _detailStoryResult;
  late ResultState _state;
  String _message = '';

  DetailStoryResult get detailStoryResult => _detailStoryResult;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> _fetchDetailStory(String id) async {
    _state = ResultState.loading;
    notifyListeners();
    final user = await authRepository.getUser();

    if (user != null) {
      final token = user.token;
      final story = await apiService.detailStory(token, id);
      if (story.error) {
        _message = story.message;
        notifyListeners();
        return _message;
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detailStoryResult = story;
      }
    }
  }
}
