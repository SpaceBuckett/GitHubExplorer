import 'package:flutter/material.dart';
import 'package:github_explorer_1o1/core/static/colors.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_LogoIcon(), const SizedBox(height: 20), _AppTitle()],
    );
  }
}

class _LogoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: kCardColor,
        shape: BoxShape.circle,
        border: Border.all(color: kGreenNeon, width: 2),
        boxShadow: [
          BoxShadow(
            color: kGreenNeon.withOpacity(0.25),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(Icons.code_rounded, color: kGreenNeon, size: 48),
    );
  }
}

class _AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'GitHub',
            style: TextStyle(
              color: kWhiteTextColor,
              fontSize: 26,
              fontWeight: FontWeight.w300,
              letterSpacing: 1,
            ),
          ),
          TextSpan(
            text: ' Explorer',
            style: TextStyle(
              color: kGreenNeon,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
