import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/breed_marks.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/breed_photo.dart';
import 'package:flutter/material.dart';

class BreedCard extends StatelessWidget {
  const BreedCard({required this.breed, required this.onOpen, super.key});

  final Breed breed;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final origin = breed.origin.trim();
    final life = breed.lifeSpan.trim();
    final coat = breed.breedGroup.trim();
    final weight = breed.weight.trim();
    final description = breed.description.trim();
    final traits = breedTraits(breed.temperament);
    final stats = [
      if (life.isNotEmpty) _Stat(Icons.favorite_border, '$life years'),
      if (coat.isNotEmpty) _Stat(Icons.pets, coat),
      if (weight.isNotEmpty) _Stat(Icons.monitor_weight_outlined, '$weight kg'),
    ];

    return Semantics(
      button: true,
      label: 'Details of ${breed.name}',
      child: ExcludeSemantics(
        child: BreedCardSurface(
          child: InkWell(
            onTap: onOpen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: AppMeasure.cardPhotoAspect,
                      child: BreedPhoto(
                        name: breed.name,
                        url: breed.imageUrl,
                        heroTag: 'breed-photo-${breed.id}',
                      ),
                    ),
                    if (origin.isNotEmpty)
                      Positioned(
                        left: AppSpace.md,
                        top: AppSpace.md,
                        child: OriginPill(
                          origin: origin,
                          countryCode: breed.countryCode,
                        ),
                      ),
                    if (stats.isNotEmpty)
                      Positioned(
                        left: AppSpace.md,
                        right: AppSpace.md,
                        bottom: AppSpace.md,
                        child: _StatBar(stats: stats),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpace.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(breed.name, style: theme.textTheme.headlineSmall),
                      if (coat.isNotEmpty) ...[
                        const SizedBox(height: AppSpace.xxs),
                        Text(
                          coat,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: AppSpace.md),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                      if (traits.isNotEmpty) ...[
                        const SizedBox(height: AppSpace.md),
                        TraitChips(temperament: breed.temperament, maxRows: 2),
                      ],
                      const SizedBox(height: AppSpace.md),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'See details',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BreedCardSurface extends StatelessWidget {
  const BreedCardSurface({required this.child, super.key});

  final Widget child;

  static const _edge = 1.5;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withValues(alpha: 0.55),
            primary.withValues(alpha: 0.14),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(_edge),
        child: Material(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.card - _edge),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}

class _Stat {
  const _Stat(this.icon, this.label);

  final IconData icon;
  final String label;
}

class _StatBar extends StatelessWidget {
  const _StatBar({required this.stats});

  final List<_Stat> stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: AppSpace.sm,
        ),
        child: Row(
          children: [
            for (var index = 0; index < stats.length; index++) ...[
              if (index > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
                  child: Text('·', style: theme.textTheme.bodyMedium),
                ),
              Icon(stats[index].icon, size: 16, color: scheme.primary),
              const SizedBox(width: AppSpace.xs),
              Flexible(
                child: Text(
                  stats[index].label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
