import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:flutter/material.dart';

class BreedSkeleton extends StatelessWidget {
  const BreedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outline;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: AppMeasure.cardPhotoAspect,
            child: ColoredBox(color: color),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 140, height: 22, color: color),
                const SizedBox(height: AppSpace.sm),
                Container(width: 96, height: 16, color: color),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
