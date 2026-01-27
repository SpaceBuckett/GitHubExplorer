import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_explorer_1o1/core/routes/app_router.dart';
import 'package:github_explorer_1o1/core/static/colors.dart';
import 'package:github_explorer_1o1/firebase_options.dart';
import 'package:github_explorer_1o1/ui/home/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HomeViewModel())],
      child: GetMaterialApp(
        title: 'GitHub Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: kGreenNeon,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: kBackgroundColor,
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.splashScreen,
        getPages: AppRoutes.pages,
      ),
    );
  }
}
