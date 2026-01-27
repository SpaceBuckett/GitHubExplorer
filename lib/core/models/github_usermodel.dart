class RepositoryModel {
  final int id;
  final String name;
  final String? description;
  final String htmlUrl;
  final int stargazersCount;
  final int forksCount;
  final int watchersCount;
  final String? language;
  final bool isPrivate;
  final String? avatarUrl;
  final int openIssuesCount;
  final String defaultBranch;
  final DateTime? updatedAt;

  RepositoryModel({
    required this.id,
    required this.name,
    this.description,
    required this.htmlUrl,
    required this.stargazersCount,
    required this.forksCount,
    required this.watchersCount,
    this.language,
    required this.isPrivate,
    this.avatarUrl,
    required this.openIssuesCount,
    required this.defaultBranch,
    this.updatedAt,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    return RepositoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      htmlUrl: json['html_url'] ?? '',
      stargazersCount: json['stargazers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
      watchersCount: json['watchers_count'] ?? 0,
      language: json['language'],
      isPrivate: json['private'] ?? false,
      avatarUrl: json['owner']?['avatar_url'],
      openIssuesCount: json['open_issues_count'] ?? 0,
      defaultBranch: json['default_branch'] ?? 'main',
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'html_url': htmlUrl,
      'stargazers_count': stargazersCount,
      'forks_count': forksCount,
      'watchers_count': watchersCount,
      'language': language,
      'private': isPrivate,
      'open_issues_count': openIssuesCount,
      'default_branch': defaultBranch,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class GitHubUserModel {
  final int id;
  final String login;
  final String avatarUrl;
  final String? name;
  final String? bio;
  final int publicRepos;
  final int followers;
  final int following;

  GitHubUserModel({
    required this.id,
    required this.login,
    required this.avatarUrl,
    this.name,
    this.bio,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });

  factory GitHubUserModel.fromJson(Map<String, dynamic> json) {
    return GitHubUserModel(
      id: json['id'] ?? 0,
      login: json['login'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      name: json['name'],
      bio: json['bio'],
      publicRepos: json['public_repos'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
    );
  }
}
