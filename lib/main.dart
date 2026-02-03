import 'package:esame/features/authentification/view/login_pages.dart';
import 'package:esame/features/authentification/view/sign_up_pages.dart';
import 'package:esame/features/authentification/viewmodel/sign_up_viewmodel.dart';
import 'package:esame/features/home/view/animated_nav_bar.dart';
import 'package:esame/features/home/view/home_view.dart';
import 'package:esame/features/intro/view/intro_view.dart';
import 'package:esame/features/intro/viewmodel/intro_viewmodel.dart';
import 'package:esame/features/authentification/viewmodel/login_viewmodel.dart';
import 'package:esame/features/intro/view/welcome_view.dart';
import 'package:esame/features/home/viewmodel/recipe_viewmodel.dart';
import 'package:esame/features/home/viewmodel/chef_viewmodel.dart';
import 'package:esame/core/them/app_theme.dart';
import 'package:esame/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewmodel()),
        ChangeNotifierProvider(create: (_) => IntroViewmodel()),
        ChangeNotifierProvider(create: (_) => RecipeViewModel()),
        ChangeNotifierProvider(create: (_) => ChefViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: kIsWeb ? const Size(1000, 800) : const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SouChef',
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          home: child,
        );
      },
      child: const WelcomeView(),
    );
  }
}
