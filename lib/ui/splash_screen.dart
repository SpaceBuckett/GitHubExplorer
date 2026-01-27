import 'package:flutter/material.dart';
import 'package:github_explorer_1o1/core/routes/app_router.dart';
import 'package:github_explorer_1o1/core/services/auth_service.dart';
import 'package:github_explorer_1o1/core/static/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuthAndNavigate();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    final authService = AuthService();
    if (authService.isLoggedIn) {
      AppRoutes.goToHome();
    } else {
      AppRoutes.goToAuth();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(scale: _scaleAnimation, child: child),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: kCardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: kGreenNeon, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: kGreenNeon.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.code, color: kGreenNeon, size: 56),
              ),
              const SizedBox(height: 32),
              const Text(
                'GitHub Explorer',
                style: TextStyle(
                  color: kWhiteTextColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Discover amazing repositories',
                style: TextStyle(color: kSecondaryTextColor, fontSize: 14),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: kGreenNeon,
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
