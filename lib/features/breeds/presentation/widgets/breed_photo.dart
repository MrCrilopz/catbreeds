import 'package:cached_network_image/cached_network_image.dart';
import 'package:catbreeds/core/constants/app_assets.dart';
import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:flutter/material.dart';

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
    return Padding(
      padding: padding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card - 1),
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
        final cacheWidth = (width * MediaQuery.devicePixelRatioOf(context))
            .round()
            .clamp(1, 1600);
        return Semantics(
          label: 'Foto de $name',
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
      label: 'Sin foto',
      image: true,
      child: ExcludeSemantics(
        child: ColoredBox(
          color: theme.colorScheme.outline,
          child: Image.asset(
            AppAssets.missingCat,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, _, _) => const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
