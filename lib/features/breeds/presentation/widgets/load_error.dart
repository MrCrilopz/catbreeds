import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:flutter/material.dart';

class LoadError extends StatelessWidget {
  const LoadError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpace.xl),
      children: [
        Text(
          'No pudimos cargar las razas. Revisa la conexión e inténtalo de nuevo.',
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpace.lg),
        Align(
          child: FilledButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ),
      ],
    );
  }
}
