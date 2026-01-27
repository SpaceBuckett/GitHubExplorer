import 'package:get/get.dart';
import 'package:github_explorer_1o1/ui/home/home_screen.dart';
import 'package:github_explorer_1o1/ui/splash_screen.dart';
import 'package:github_explorer_1o1/ui/auth/auth_screen.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String authScreen = '/auth';
  static const String homeScreen = '/home';

  static final List<GetPage> pages = [
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: authScreen,
      page: () => AuthScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];

  static void goToSplash() {
    Get.offAllNamed(splashScreen);
  }

  static void goToAuth() {
    Get.offAllNamed(authScreen);
  }

  static void goToHome() {
    Get.offAllNamed(homeScreen);
  }
}
