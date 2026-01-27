import 'package:dio/dio.dart';
import 'package:github_explorer_1o1/core/models/github_usermodel.dart';
import 'package:github_explorer_1o1/core/services/dio_service.dart';

class GitHubService {
  final Dio _dio = DioService().dio;

  Future<GitHubUserModel?> getUserProfile(String username) async {
    try {
      final response = await _dio.get('/users/$username');
      if (response.statusCode == 200) {
        return GitHubUserModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('User not found');
      }
      print('Error fetching user profile: ${e.message}');
      rethrow;
    }
  }

  Future<List<RepositoryModel>> getUserRepositories(
    String username, {
    String sort = 'updated',
    String direction = 'desc',
    int perPage = 30,
  }) async {
    try {
      final response = await _dio.get(
        '/users/$username/repos',
        queryParameters: {
          'sort': sort,
          'direction': direction,
          'per_page': perPage,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => RepositoryModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('Error fetching repositories: ${e.message}');
      rethrow;
    }
  }

  Future<RepositoryModel?> getRepository(
    String username,
    String repoName,
  ) async {
    try {
      final response = await _dio.get('/repos/$username/$repoName');
      if (response.statusCode == 200) {
        return RepositoryModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print('Error fetching repository: ${e.message}');
      rethrow;
    }
  }
}
