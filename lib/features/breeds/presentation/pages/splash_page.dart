import 'dart:async';

import 'package:catbreeds/core/constants/app_assets.dart';
import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_event.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_state.dart';
import 'package:catbreeds/features/breeds/presentation/pages/breed_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _hold = Duration(milliseconds: 600);

class SplashPage extends StatefulWidget {
  const SplashPage({this.missingCredentials = false, super.key});

  final bool missingCredentials;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  var _holdDone = false;
  var _left = false;

  @override
  void initState() {
    super.initState();
    if (widget.missingCredentials) {
      return;
    }
    context.read<BreedsBloc>().add(const BreedsRequested());
    _timer = Timer(_hold, () {
      if (!mounted) {
        return;
      }
      setState(() => _holdDone = true);
      _tryLeave();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tryLeave() {
    if (_left || !_holdDone || !mounted || widget.missingCredentials) {
      return;
    }
    final state = context.read<BreedsBloc>().state;
    if (state is BreedsInitial || state is BreedsLoading) {
      return;
    }
    _left = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        settings: const RouteSettings(name: BreedListPage.route),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, _, _) => const BreedListPage(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final body = SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CATÁLOGO FELINO',
                style: theme.textTheme.labelMedium?.copyWith(
                  letterSpacing: 2,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            const Spacer(),
            const _SplashMark(),
            const SizedBox(height: AppSpace.lg),
            Text('Catbreeds', style: theme.textTheme.displaySmall),
            const SizedBox(height: AppSpace.xs),
            Text(
              'Razas de gatos',
              style: theme.textTheme.titleMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            if (widget.missingCredentials)
              Text(
                'Falta la clave de The Cat API. Copia .env.example a .env y vuelve a correr la app.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              )
            else ...[
              Text(
                'Descubriendo razas',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpace.md),
              BlocBuilder<BreedsBloc, BreedsState>(
                builder: (context, state) {
                  final waiting =
                      state is BreedsInitial || state is BreedsLoading;
                  if (!_holdDone || !waiting) {
                    return const SizedBox(
                      height: AppSpace.xs,
                      width: AppMeasure.progress,
                    );
                  }
                  return const SizedBox(
                    width: AppMeasure.progress,
                    child: LinearProgressIndicator(
                      semanticsLabel: 'Cargando razas',
                    ),
                  );
                },
              ),
            ],
            const Spacer(),
          ],
        ),
      ),
    );

    if (widget.missingCredentials) {
      return Scaffold(body: body);
    }

    return BlocListener<BreedsBloc, BreedsState>(
      listener: (_, _) => _tryLeave(),
      child: Scaffold(body: body),
    );
  }
}

class _SplashMark extends StatelessWidget {
  const _SplashMark();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 148,
      height: 148,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.surfaceContainerLow,
                border: Border.all(color: scheme.outline),
              ),
              child: const Padding(
                padding: EdgeInsets.all(AppSpace.xl),
                child: Image(
                  image: AssetImage(AppAssets.splashCat),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.secondary,
                shape: BoxShape.circle,
              ),
              child: const SizedBox.square(dimension: 18),
            ),
          ),
        ],
      ),
    );
  }
}
