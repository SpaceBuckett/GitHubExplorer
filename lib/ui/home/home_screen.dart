import 'package:flutter/material.dart';
import 'package:github_explorer_1o1/core/models/github_usermodel.dart';
import 'package:github_explorer_1o1/core/routes/app_router.dart';
import 'package:github_explorer_1o1/core/services/auth_service.dart';
import 'package:github_explorer_1o1/core/static/colors.dart';
import 'package:github_explorer_1o1/ui/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _searchUser() {
    _focusNode.unfocus();
    final username = _usernameController.text.trim();
    if (username.isNotEmpty) {
      context.read<HomeViewModel>().fetchUserData(username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: const Text(
          'GitHub Explorer',
          style: TextStyle(
            color: kWhiteTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Consumer<HomeViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.hasSearched && !viewModel.isIdle) {
                return IconButton(
                  icon: const Icon(Icons.refresh, color: kGreenNeon),
                  onPressed: () => viewModel.refreshData(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: kErrorColor),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(
            controller: _usernameController,
            focusNode: _focusNode,
            onSearch: _searchUser,
            onClear: () {
              _usernameController.clear();
              context.read<HomeViewModel>().clearData();
            },
          ),

          Expanded(
            child: Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isIdle) {
                  return const _IdleView();
                }

                if (viewModel.isLoading) {
                  return const _LoadingView();
                }

                if (viewModel.hasError) {
                  return _ErrorView(
                    message: viewModel.errorMessage ?? 'Something went wrong',
                    onRetry:
                        () => viewModel.fetchUserData(
                          _usernameController.text.trim(),
                        ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: viewModel.refreshData,
                  color: kGreenNeon,
                  backgroundColor: kCardColor,
                  child: CustomScrollView(
                    slivers: [
                      if (viewModel.user != null)
                        SliverToBoxAdapter(
                          child: _UserProfileCard(user: viewModel.user!),
                        ),

                      SliverToBoxAdapter(
                        child: _StatsRow(viewModel: viewModel),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 24, 18, 12),
                          child: Row(
                            children: [
                              const Text(
                                'Repositories',
                                style: TextStyle(
                                  color: kWhiteTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: kGreenNeon.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${viewModel.repositories.length}',
                                  style: const TextStyle(
                                    color: kGreenNeon,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (viewModel.hasData)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              return _RepositoryCard(
                                repository: viewModel.repositories[index],
                              );
                            }, childCount: viewModel.repositories.length),
                          ),
                        )
                      else
                        const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Text(
                                'No repositories found',
                                style: TextStyle(color: kSecondaryTextColor),
                              ),
                            ),
                          ),
                        ),

                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: kCardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Text(
              'Logout',
              style: TextStyle(color: kWhiteTextColor),
            ),
            content: const Text(
              'Are you sure you want to logout?',
              style: TextStyle(color: kGreyTextColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: kSecondaryTextColor),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await AuthService().signOut();
                  AppRoutes.goToAuth();
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: kErrorColor),
                ),
              ),
            ],
          ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Container(
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kCardBorderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(color: kWhiteTextColor, fontSize: 16),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => onSearch(),
                decoration: const InputDecoration(
                  hintText: 'Enter GitHub username...',
                  hintStyle: TextStyle(color: kSecondaryTextColor),
                  prefixIcon: Icon(Icons.person_search, color: kGreenNeon),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            Consumer<HomeViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.hasSearched) {
                  return IconButton(
                    icon: const Icon(Icons.close, color: kSecondaryTextColor),
                    onPressed: onClear,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Container(
              margin: const EdgeInsets.only(right: 6),
              child: Material(
                color: kGreenNeon,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onSearch,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: kBackgroundColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kCardColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: kGreenNeon.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(Icons.search, color: kGreenNeon, size: 48),
            ),
            const SizedBox(height: 24),
            const Text(
              'Explore GitHub Profiles',
              style: TextStyle(
                color: kWhiteTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter a GitHub username above to view\ntheir profile and repositories',
              textAlign: TextAlign.center,
              style: TextStyle(color: kSecondaryTextColor, fontSize: 14),
            ),
            const SizedBox(height: 32),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _SuggestionChip(
                  label: 'torvalds',
                  onTap: () => _searchUser(context, 'torvalds'),
                ),
                _SuggestionChip(
                  label: 'spacebuckett',
                  onTap: () => _searchUser(context, 'spacebuckett'),
                ),
                _SuggestionChip(
                  label: 'flutter',
                  onTap: () => _searchUser(context, 'flutter'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Try these suggestions',
              style: TextStyle(color: kSecondaryTextColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _searchUser(BuildContext context, String username) {
    context.read<HomeViewModel>().fetchUserData(username);
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kCardColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kGreenNeon.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline, color: kGreenNeon, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: kGreenNeon, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(color: kGreenNeon, strokeWidth: 3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Loading repositories...',
            style: TextStyle(color: kGreyTextColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: kErrorColor, size: 64),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: kGreyTextColor, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreenNeon,
                foregroundColor: kBackgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  final GitHubUserModel user;

  const _UserProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kCardBorderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kGreenNeon, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                user.avatarUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kGreenNeon,
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, color: kGreenNeon, size: 36);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? user.login,
                  style: const TextStyle(
                    color: kWhiteTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user.login}',
                  style: const TextStyle(color: kGreenNeon, fontSize: 14),
                ),
                if (user.bio != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    user.bio!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kSecondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final HomeViewModel viewModel;

  const _StatsRow({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.folder_outlined,
              label: 'Repos',
              value: '${viewModel.repositories.length}',
              color: kBlueAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.star_outline,
              label: 'Stars',
              value: '${viewModel.totalStars}',
              color: kYellowAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.call_split,
              label: 'Forks',
              value: '${viewModel.totalForks}',
              color: kPurpleAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: kSecondaryTextColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _RepositoryCard extends StatelessWidget {
  final RepositoryModel repository;

  const _RepositoryCard({required this.repository});

  @override
  Widget build(BuildContext context) {
    final languageColor =
        repository.language != null
            ? languageColors[repository.language] ?? kSecondaryTextColor
            : kSecondaryTextColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                repository.isPrivate ? Icons.lock_outline : Icons.public,
                color: kSecondaryTextColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  repository.name,
                  style: const TextStyle(
                    color: kGreenNeon,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          if (repository.description != null) ...[
            const SizedBox(height: 8),
            Text(
              repository.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: kSecondaryTextColor, fontSize: 13),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (repository.language != null) ...[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: languageColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  repository.language!,
                  style: const TextStyle(color: kGreyTextColor, fontSize: 12),
                ),
                const SizedBox(width: 16),
              ],

              const Icon(Icons.star_outline, color: kYellowAccent, size: 16),
              const SizedBox(width: 4),
              Text(
                '${repository.stargazersCount}',
                style: const TextStyle(color: kGreyTextColor, fontSize: 12),
              ),
              const SizedBox(width: 16),

              const Icon(Icons.call_split, color: kPurpleAccent, size: 16),
              const SizedBox(width: 4),
              Text(
                '${repository.forksCount}',
                style: const TextStyle(color: kGreyTextColor, fontSize: 12),
              ),

              const Spacer(),

              const Icon(
                Icons.account_tree_outlined,
                color: kSecondaryTextColor,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                repository.defaultBranch,
                style: const TextStyle(
                  color: kSecondaryTextColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
