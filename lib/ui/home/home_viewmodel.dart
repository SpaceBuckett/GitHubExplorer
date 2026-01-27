import 'package:flutter/foundation.dart';
import 'package:github_explorer_1o1/core/models/github_usermodel.dart';
import 'package:github_explorer_1o1/core/services/db_service.dart';

enum ViewState { idle, loading, success, error }

class HomeViewModel extends ChangeNotifier {
  final GitHubService _gitHubService = GitHubService();

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<RepositoryModel> _repositories = [];
  List<RepositoryModel> get repositories => _repositories;

  GitHubUserModel? _user;
  GitHubUserModel? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _currentUsername = '';
  String get currentUsername => _currentUsername;

  bool get isLoading => _state == ViewState.loading;
  bool get hasError => _state == ViewState.error;
  bool get hasData => _repositories.isNotEmpty;
  bool get isIdle => _state == ViewState.idle;
  bool get hasSearched => _currentUsername.isNotEmpty;

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> fetchUserData(String username) async {
    if (username.trim().isEmpty) {
      _errorMessage = 'Please enter a username';
      _setState(ViewState.error);
      return;
    }

    _currentUsername = username.trim();
    _setState(ViewState.loading);
    _errorMessage = null;

    try {
      // Fetch user profile and repositories in parallel
      final results = await Future.wait([
        _gitHubService.getUserProfile(_currentUsername),
        _gitHubService.getUserRepositories(_currentUsername),
      ]);

      _user = results[0] as GitHubUserModel?;
      _repositories = results[1] as List<RepositoryModel>;

      if (_user == null) {
        _errorMessage = 'User "$_currentUsername" not found';
        _setState(ViewState.error);
        return;
      }

      _setState(ViewState.success);
    } catch (e) {
      if (e.toString().contains('User not found')) {
        _errorMessage = 'User "$_currentUsername" not found on GitHub';
      } else {
        _errorMessage = 'Failed to fetch data. Please check your connection.';
      }
      _setState(ViewState.error);
    }
  }

  Future<void> refreshData() async {
    if (_currentUsername.isNotEmpty) {
      await fetchUserData(_currentUsername);
    }
  }

  void clearData() {
    _user = null;
    _repositories = [];
    _currentUsername = '';
    _errorMessage = null;
    _setState(ViewState.idle);
  }

  int get totalStars {
    return _repositories.fold(0, (sum, repo) => sum + repo.stargazersCount);
  }

  int get totalForks {
    return _repositories.fold(0, (sum, repo) => sum + repo.forksCount);
  }

  Map<String, int> get languageStats {
    final Map<String, int> stats = {};
    for (final repo in _repositories) {
      if (repo.language != null) {
        stats[repo.language!] = (stats[repo.language!] ?? 0) + 1;
      }
    }
    return stats;
  }
}
