import 'package:flutter/material.dart';
import 'package:github_explorer_1o1/core/static/colors.dart';

class AuthWelcomeText extends StatelessWidget {
  const AuthWelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Discover & Explore',
          style: TextStyle(
            color: kWhiteTextColor,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Browse GitHub profiles, explore repositories,\nand track your favorite developers',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kGreyTextColor.withOpacity(0.8),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
