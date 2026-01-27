import 'package:flutter/material.dart';
import 'package:github_explorer_1o1/core/static/colors.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    required this.onTap,
    required this.isLoading,
    super.key,
  });

  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _GetStartedDivider(),
        const SizedBox(height: 24),
        _GoogleButton(onTap: onTap, isLoading: isLoading),
      ],
    );
  }
}

class _GetStartedDivider extends StatelessWidget {
  const _GetStartedDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: kCardBorderColor)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Get started',
            style: TextStyle(color: kSecondaryTextColor, fontSize: 13),
          ),
        ),
        Expanded(child: Container(height: 1, color: kCardBorderColor)),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.onTap, required this.isLoading});

  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 56,
          decoration: BoxDecoration(
            color: isLoading ? kCardColor : kWhiteTextColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow:
                isLoading
                    ? []
                    : [
                      BoxShadow(
                        color: kWhiteTextColor.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
          ),
          child:
              isLoading
                  ? const _LoadingIndicator()
                  : const _GoogleButtonContent(),
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(color: kGreenNeon, strokeWidth: 2.5),
      ),
    );
  }
}

class _GoogleButtonContent extends StatelessWidget {
  const _GoogleButtonContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/icons/GoogleLogo.png', height: 24, width: 24),
        const SizedBox(width: 12),
        const Text(
          'Continue with Google',
          style: TextStyle(
            color: kBackgroundColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
