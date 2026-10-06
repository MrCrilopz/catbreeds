import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:flutter/material.dart';

class FactGrid extends StatelessWidget {
  const FactGrid({required this.breed, super.key});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final life = breed.lifeSpan.trim();
    final weight = breed.weight.trim();
    final height = breed.height.trim();
    final coat = breed.breedGroup.trim();
    final facts = [
      if (life.isNotEmpty)
        _Fact(
          icon: Icons.favorite_border,
          label: 'Longevidad',
          value: '$life años',
        ),
      if (weight.isNotEmpty)
        _Fact(
          icon: Icons.monitor_weight_outlined,
          label: 'Peso',
          value: '$weight kg',
        ),
      if (height.isNotEmpty)
        _Fact(icon: Icons.straighten, label: 'Altura', value: '$height cm'),
      if (coat.isNotEmpty)
        _Fact(icon: Icons.pets, label: 'Pelaje', value: coat),
    ];
    if (facts.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(1);
        final stacked =
            scale > 1.3 || constraints.maxWidth < AppMeasure.factStack;
        final rows = stacked
            ? [
                for (final fact in facts) [fact],
              ]
            : [
                for (var index = 0; index < facts.length; index += 2)
                  facts.sublist(
                    index,
                    index + 2 > facts.length ? facts.length : index + 2,
                  ),
              ];
        return Column(
          children: [
            for (var index = 0; index < rows.length; index++) ...[
              if (index > 0) const SizedBox(height: AppSpace.md),
              _row(rows[index]),
            ],
          ],
        );
      },
    );
  }

  Widget _row(List<_Fact> facts) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < facts.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpace.md),
          Expanded(child: _FactTile(fact: facts[index])),
        ],
        if (facts.length == 1) ...[
          const SizedBox(width: AppSpace.md),
          const Expanded(child: SizedBox.shrink()),
        ],
      ],
    );
  }
}

class _Fact {
  const _Fact({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;
}

class _FactTile extends StatelessWidget {
  const _FactTile({required this.fact});

  final _Fact fact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: scheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(fact.icon, size: 18, color: scheme.primary),
            const SizedBox(height: AppSpace.sm),
            Text(
              fact.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: AppSpace.xxs),
            Text(fact.value, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
