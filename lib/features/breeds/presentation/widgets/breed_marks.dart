import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:flutter/material.dart';

List<String> breedTraits(String temperament) {
  return [
    for (final part in temperament.split(','))
      if (part.trim().isNotEmpty) part.trim(),
  ];
}

String countryFlag(String code) {
  final upper = code.trim().toUpperCase();
  if (upper.length != 2 || !RegExp(r'^[A-Z]{2}$').hasMatch(upper)) {
    return '';
  }
  return String.fromCharCodes(
    upper.codeUnits.map((unit) => unit + 0x1F1E6 - 0x41),
  );
}

class OriginPill extends StatelessWidget {
  const OriginPill({required this.origin, this.countryCode = '', super.key});

  final String origin;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final place = origin.trim();
    if (place.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final flag = countryFlag(countryCode);
    final label = flag.isEmpty ? place : '$flag $place';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: AppSpace.xs,
        ),
        child: Text(label, style: theme.textTheme.labelLarge),
      ),
    );
  }
}

class TraitChips extends StatelessWidget {
  const TraitChips({required this.temperament, this.maxRows, super.key});

  final String temperament;
  final int? maxRows;

  @override
  Widget build(BuildContext context) {
    final traits = breedTraits(temperament);
    if (traits.isEmpty) {
      return const SizedBox.shrink();
    }
    final scheme = Theme.of(context).colorScheme;
    final tones = [scheme.primary, scheme.tertiary, scheme.secondary];
    final limit = maxRows;
    if (limit == null) {
      return _wrap(traits, tones);
    }
    final style =
        Theme.of(context).textTheme.labelLarge ?? const TextStyle(fontSize: 14);
    final scaler = MediaQuery.textScalerOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final shown = constraints.maxWidth.isFinite
            ? _fitTraits(traits, constraints.maxWidth, style, scaler, limit)
            : traits;
        return _wrap(shown, tones);
      },
    );
  }

  Widget _wrap(List<String> labels, List<Color> tones) {
    return Wrap(
      spacing: AppSpace.sm,
      runSpacing: AppSpace.sm,
      children: [
        for (var index = 0; index < labels.length; index++)
          _TraitChip(
            label: labels[index],
            color: labels[index] == _moreTraits
                ? tones.first
                : tones[index % tones.length],
            more: labels[index] == _moreTraits,
          ),
      ],
    );
  }
}

const _moreTraits = '…';

List<String> _fitTraits(
  List<String> traits,
  double maxWidth,
  TextStyle style,
  TextScaler scaler,
  int maxRows,
) {
  final widths = [for (final trait in traits) _chipWidth(trait, style, scaler)];
  final moreWidth = _chipWidth(_moreTraits, style, scaler);
  final rows = <List<int>>[];
  var row = <int>[];
  var used = 0.0;
  for (var index = 0; index < traits.length; index++) {
    final gap = row.isEmpty ? 0.0 : AppSpace.sm;
    if (row.isNotEmpty && used + gap + widths[index] > maxWidth) {
      rows.add(row);
      row = [index];
      used = widths[index];
    } else {
      row.add(index);
      used += gap + widths[index];
    }
  }
  if (row.isNotEmpty) {
    rows.add(row);
  }
  if (rows.length <= maxRows) {
    return traits;
  }

  final kept = <int>[];
  for (var line = 0; line < maxRows - 1; line++) {
    kept.addAll(rows[line]);
  }
  final last = rows[maxRows - 1];
  var lastUsed = 0.0;
  final lastKept = <int>[];
  for (final index in last) {
    final gap = lastKept.isEmpty ? 0.0 : AppSpace.sm;
    final withChip = lastUsed + gap + widths[index];
    final withMore = withChip + AppSpace.sm + moreWidth;
    if (withMore > maxWidth) {
      break;
    }
    lastKept.add(index);
    lastUsed = withChip;
  }
  kept.addAll(lastKept);
  return [for (final index in kept) traits[index], _moreTraits];
}

double _chipWidth(String label, TextStyle style, TextScaler scaler) {
  final painter = TextPainter(
    text: TextSpan(text: label, style: style),
    textDirection: TextDirection.ltr,
    textScaler: scaler,
    maxLines: 1,
  )..layout();
  final mark = label == _moreTraits ? 0.0 : 8 + AppSpace.xs;
  return painter.width + AppSpace.md * 2 + mark;
}

class _TraitChip extends StatelessWidget {
  const _TraitChip({
    required this.label,
    required this.color,
    this.more = false,
  });

  final String label;
  final Color color;
  final bool more;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: AppSpace.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!more) ...[
              DecoratedBox(
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const SizedBox.square(dimension: 8),
              ),
              const SizedBox(width: AppSpace.xs),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: more
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
