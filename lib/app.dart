import 'package:flutter/material.dart';

import 'package:catbreeds/core/theme/app_theme.dart';
import 'package:catbreeds/features/breeds/presentation/pages/splash_page.dart';

class CatbreedsApp extends StatelessWidget {
  const CatbreedsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catbreeds',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
    );
  }
}
