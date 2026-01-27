import 'package:flutter/material.dart';
import 'package:github_explorer_1o1/core/static/colors.dart';

class AuthTermsText extends StatelessWidget {
  const AuthTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          color: kSecondaryTextColor.withOpacity(0.7),
          fontSize: 12,
          height: 1.5,
        ),
        children: const [
          TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(color: kGreenNeon, fontWeight: FontWeight.w500),
          ),
          TextSpan(text: '\nand '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(color: kGreenNeon, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
