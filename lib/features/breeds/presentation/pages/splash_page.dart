import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:catbreeds/core/constants/app_assets.dart';
import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_event.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_state.dart';
import 'package:catbreeds/features/breeds/presentation/pages/breed_list_page.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/breed_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _hold = Duration(seconds: 1);
const _photoWait = Duration(seconds: 4);
const _firstPhotos = 4;

class SplashPage extends StatefulWidget {
  const SplashPage({this.missingCredentials = false, super.key});

  final bool missingCredentials;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  Future<void>? _photos;
  var _holdDone = false;
  var _left = false;
  var _photosJoined = false;

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

  void _onCatalog(BreedsState state) {
    if (state is BreedsReady) {
      _photos ??= _warmFirstPhotos(state);
    }
    _tryLeave();
  }

  Future<void> _warmFirstPhotos(BreedsReady state) async {
    final urls = <String>[];
    for (final breed in state.visible) {
      final url = breed.imageUrl?.trim();
      if (url == null || url.isEmpty) {
        continue;
      }
      urls.add(url);
      if (urls.length == _firstPhotos) {
        break;
      }
    }
    if (!mounted || urls.isEmpty) {
      return;
    }
    final media = MediaQuery.of(context);
    final cacheWidth = breedPhotoCacheWidth(
      listCardPhotoWidth(media.size.width),
      media.devicePixelRatio,
    );
    try {
      await Future.wait(urls.map((url) => _warmOne(url, cacheWidth)))
          .timeout(_photoWait);
    } on TimeoutException {
      return;
    }
  }

  Future<void> _warmOne(String url, int cacheWidth) async {
    try {
      if (!mounted) {
        return;
      }
      await precacheImage(
        ResizeImage(CachedNetworkImageProvider(url), width: cacheWidth),
        context,
      );
    } catch (_) {
      return;
    }
  }

  void _tryLeave() {
    if (_left || !_holdDone || !mounted || widget.missingCredentials) {
      return;
    }
    final state = context.read<BreedsBloc>().state;
    if (state is BreedsInitial || state is BreedsLoading) {
      return;
    }
    final photos = _photos;
    if (photos != null) {
      if (_photosJoined) {
        return;
      }
      _photosJoined = true;
      photos.whenComplete(_leave);
      return;
    }
    _leave();
  }

  void _leave() {
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
                'FELINE CATALOG',
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
              'Cat breeds',
              style: theme.textTheme.titleMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            if (widget.missingCredentials)
              Text(
                'The Cat API key is missing. Copy .env.example to .env and run the app again.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              )
            else ...[
              Text(
                'Discovering breeds',
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
                      semanticsLabel: 'Loading breeds',
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
      listener: (_, state) => _onCatalog(state),
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
