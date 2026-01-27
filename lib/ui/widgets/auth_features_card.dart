import 'package:flutter/material.dart';
import 'package:github_explorer_1o1/core/static/colors.dart';

class AuthFeaturesCard extends StatelessWidget {
  const AuthFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kCardBorderColor),
      ),
      child: const Column(
        children: [
          FeatureItem(
            icon: Icons.person_search_rounded,
            title: 'Search Profiles',
            subtitle: 'Find any GitHub user instantly',
          ),
          SizedBox(height: 16),
          FeatureItem(
            icon: Icons.folder_copy_rounded,
            title: 'View Repositories',
            subtitle: 'Browse repos, stars, and forks',
          ),
          SizedBox(height: 16),
          FeatureItem(
            icon: Icons.analytics_rounded,
            title: 'Track Statistics',
            subtitle: 'See detailed profile analytics',
          ),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  const FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FeatureIcon(icon: icon),
        const SizedBox(width: 14),
        Expanded(child: _FeatureText(title: title, subtitle: subtitle)),
        Icon(Icons.check_circle, color: kGreenNeon.withOpacity(0.6), size: 18),
      ],
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  const _FeatureIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: kGreenNeon.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: kGreenNeon, size: 22),
    );
  }
}

class _FeatureText extends StatelessWidget {
  const _FeatureText({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kWhiteTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            color: kSecondaryTextColor.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
