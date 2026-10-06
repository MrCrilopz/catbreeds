import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:flutter/material.dart';

class EmptySearch extends StatelessWidget {
  const EmptySearch({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpace.xl),
      children: [
        Text(
          'Ninguna raza coincide con «$query».',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
