import 'package:cached_network_image/cached_network_image.dart';
import 'package:catbreeds/core/constants/app_assets.dart';
import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:flutter/material.dart';

int breedPhotoCacheWidth(double logicalWidth, double devicePixelRatio) {
  final width = logicalWidth.isFinite && logicalWidth > 0 ? logicalWidth : 360;
  return (width * devicePixelRatio).round().clamp(1, 1600);
}

double listCardPhotoWidth(double viewportWidth) {
  final board = viewportWidth > AppMeasure.content
      ? AppMeasure.content
      : viewportWidth;
  final columns = viewportWidth >= AppMeasure.expanded ? 2 : 1;
  final gap = columns == 2 ? AppSpace.lg : 0.0;
  return (board - AppSpace.lg * 2 - gap) / columns;
}

class BreedPhoto extends StatelessWidget {
  const BreedPhoto({required this.name, this.url, this.heroTag, super.key});

  final String name;
  final String? url;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url?.trim();
    final photo = imageUrl == null || imageUrl.isEmpty
        ? const MissingBreedPhoto()
        : _NetworkBreedPhoto(name: name, url: imageUrl);
    final tag = heroTag;
    if (tag == null || tag.isEmpty) {
      return photo;
    }
    return Hero(tag: tag, child: photo);
  }
}

class BreedPhotoFrame extends StatelessWidget {
  const BreedPhotoFrame({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpace.md,
      AppSpace.md,
      AppSpace.md,
      0,
    ),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.vertical(top: Radius.circular(AppRadius.card));
    const clip = BorderRadius.vertical(
      top: Radius.circular(AppRadius.card - 1),
    );
    return Padding(
      padding: padding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: ClipRRect(
          borderRadius: clip,
          child: AspectRatio(aspectRatio: AppMeasure.photoAspect, child: child),
        ),
      ),
    );
  }
}

class _NetworkBreedPhoto extends StatelessWidget {
  const _NetworkBreedPhoto({required this.name, required this.url});

  final String name;
  final String url;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 360.0;
        final cacheWidth = breedPhotoCacheWidth(
          width,
          MediaQuery.devicePixelRatioOf(context),
        );
        return Semantics(
          label: 'Photo of $name',
          image: true,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            memCacheWidth: cacheWidth,
            fadeInDuration: const Duration(milliseconds: 280),
            fadeOutDuration: Duration.zero,
            placeholder: (context, _) {
              return ColoredBox(color: Theme.of(context).colorScheme.outline);
            },
            errorWidget: (_, _, _) => const MissingBreedPhoto(),
          ),
        );
      },
    );
  }
}

class MissingBreedPhoto extends StatelessWidget {
  const MissingBreedPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'No photo',
      image: true,
      child: ExcludeSemantics(
        child: ColoredBox(
          color: theme.colorScheme.outline,
          child: Image.asset(
            AppAssets.missingCat,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, _, _) => const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
