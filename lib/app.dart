import 'package:catbreeds/core/theme/app_theme.dart';
import 'package:catbreeds/features/breeds/domain/repositories/breed_repository.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:catbreeds/features/breeds/presentation/pages/breed_detail_page.dart';
import 'package:catbreeds/features/breeds/presentation/pages/breed_list_page.dart';
import 'package:catbreeds/features/breeds/presentation/pages/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatbreedsApp extends StatelessWidget {
  const CatbreedsApp({this.repository, super.key});

  final BreedRepository? repository;

  @override
  Widget build(BuildContext context) {
    final repository = this.repository;
    final app = MaterialApp(
      title: 'Catbreeds',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      navigatorObservers: [breedRoutes],
      onGenerateRoute: (settings) => _route(settings, repository == null),
    );
    if (repository == null) {
      return app;
    }
    return BlocProvider(create: (_) => BreedsBloc(repository), child: app);
  }
}

Route<void> _route(RouteSettings settings, bool missingCredentials) {
  final page = switch (settings.name) {
    BreedListPage.route => const BreedListPage(),
    BreedDetailPage.route => BreedDetailPage(
      id: settings.arguments is String ? settings.arguments! as String : '',
    ),
    _ => SplashPage(missingCredentials: missingCredentials),
  };
  if (defaultTargetPlatform == TargetPlatform.iOS &&
      settings.name != null &&
      settings.name != '/') {
    return CupertinoPageRoute<void>(settings: settings, builder: (_) => page);
  }
  if (settings.name == BreedDetailPage.route) {
    return _softRoute(settings, page);
  }
  return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
}

Route<void> _softRoute(RouteSettings settings, Widget page) {
  return PageRouteBuilder<void>(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, _, _) => page,
    transitionsBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
