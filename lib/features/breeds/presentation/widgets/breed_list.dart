import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:catbreeds/core/layout/breakpoint_scope.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/breed_card.dart';
import 'package:flutter/material.dart';

class BreedList extends StatelessWidget {
  const BreedList({required this.breeds, required this.onOpen, super.key});

  final List<Breed> breeds;
  final ValueChanged<Breed> onOpen;

  @override
  Widget build(BuildContext context) {
    final columns = BreakpointScope.of(context) == Breakpoint.expanded ? 2 : 1;
    final rows = (breeds.length / columns).ceil();
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpace.lg,
        0,
        AppSpace.lg,
        AppSpace.lg,
      ),
      itemCount: rows,
      itemBuilder: (context, row) {
        final start = row * columns;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var column = 0; column < columns; column++) ...[
                if (column > 0) const SizedBox(width: AppSpace.lg),
                Expanded(child: _cell(start + column)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _cell(int index) {
    if (index >= breeds.length) {
      return const SizedBox.shrink();
    }
    final breed = breeds[index];
    return BreedCard(
      key: ValueKey(breed.id),
      breed: breed,
      onOpen: () => onOpen(breed),
    );
  }
}
