import 'package:flutter/material.dart';
import 'package:github_explorer_1o1/core/routes/app_router.dart';
import 'package:github_explorer_1o1/core/services/auth_service.dart';
import 'package:github_explorer_1o1/core/static/colors.dart';
import 'package:github_explorer_1o1/ui/widgets/auth_features_card.dart';
import 'package:github_explorer_1o1/ui/widgets/auth_logo.dart';
import 'package:github_explorer_1o1/ui/widgets/auth_terms_text.dart';
import 'package:github_explorer_1o1/ui/widgets/auth_welcome_text.dart';
import 'package:github_explorer_1o1/ui/widgets/google_sign_in_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<void> _handleGoogleSignIn() async {
    _setLoading(true);
    try {
      final user = await AuthService().signInWithGoogle();
      if (user != null && mounted) {
        _showSuccessSnackBar(user.displayName);
        await Future.delayed(const Duration(milliseconds: 500));
        AppRoutes.goToHome();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar();
      }
    } finally {
      _setLoading(false);
    }
  }

  void _showSuccessSnackBar(String? displayName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: kBackgroundColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Welcome back, ${displayName ?? 'User'}!',
                style: const TextStyle(
                  color: kBackgroundColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: kGreenNeon,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error_outline, color: kWhiteTextColor),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Sign in failed. Please try again.',
                style: TextStyle(color: kWhiteTextColor),
              ),
            ),
          ],
        ),
        backgroundColor: kErrorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  const AuthLogo(),
                  const SizedBox(height: 40),
                  const AuthWelcomeText(),
                  const SizedBox(height: 48),
                  const AuthFeaturesCard(),
                  const Spacer(flex: 2),
                  GoogleSignInButton(
                    onTap: _handleGoogleSignIn,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),
                  const AuthTermsText(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
