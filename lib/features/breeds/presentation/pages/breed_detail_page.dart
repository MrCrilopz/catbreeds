import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_event.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_state.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/breed_marks.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/breed_photo.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/fact_grid.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/load_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BreedDetailPage extends StatefulWidget {
  const BreedDetailPage({required this.id, super.key});

  static const route = '/breeds/detalle';

  final String id;

  @override
  State<BreedDetailPage> createState() => _BreedDetailPageState();
}

class _BreedDetailPageState extends State<BreedDetailPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<BreedsBloc>();
    if (bloc.state is BreedsInitial) {
      bloc.add(const BreedsRequested());
    }
  }

  Breed? _breed(BreedsState state) {
    if (state is! BreedsReady) {
      return null;
    }
    for (final breed in state.catalog) {
      if (breed.id == widget.id) {
        return breed;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BreedsBloc, BreedsState>(
      builder: (context, state) {
        final breed = _breed(state);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Volver',
              icon: const BackButtonIcon(),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: const SizedBox.shrink(),
          ),
          body: switch (state) {
            BreedsInitial() || BreedsLoading() => const Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Cargando razas',
              ),
            ),
            BreedsFailure() => LoadError(
              onRetry: () =>
                  context.read<BreedsBloc>().add(const BreedsRequested()),
            ),
            BreedsReady() when breed == null => const _MissingBreed(),
            BreedsReady() => _DetailBody(breed: breed!),
          },
        );
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final origin = breed.origin.trim();
    final coat = breed.breedGroup.trim();
    final description = breed.description.trim();
    final history = breed.history.trim();
    final traits = breedTraits(breed.temperament);
    final heading = theme.textTheme.labelLarge?.copyWith(
      letterSpacing: 0.8,
      fontWeight: FontWeight.w700,
      color: scheme.onSurfaceVariant,
    );
    final text = ListView(
      padding: const EdgeInsets.all(AppSpace.lg),
      children: [
        if (origin.isNotEmpty) ...[
          OriginPill(origin: origin, countryCode: breed.countryCode),
          const SizedBox(height: AppSpace.lg),
        ],
        Text(breed.name, style: theme.textTheme.headlineMedium),
        if (coat.isNotEmpty) ...[
          const SizedBox(height: AppSpace.xs),
          Text(
            coat,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
        if (breed.lifeSpan.trim().isNotEmpty ||
            breed.weight.trim().isNotEmpty ||
            breed.height.trim().isNotEmpty ||
            coat.isNotEmpty) ...[
          const SizedBox(height: AppSpace.lg),
          FactGrid(breed: breed),
        ],
        if (traits.isNotEmpty) ...[
          const SizedBox(height: AppSpace.xl),
          Text('Temperamento', style: heading),
          const SizedBox(height: AppSpace.md),
          TraitChips(temperament: breed.temperament),
        ],
        if (description.isNotEmpty) ...[
          const SizedBox(height: AppSpace.xl),
          Text('Acerca de', style: heading),
          const SizedBox(height: AppSpace.sm),
          Text(description, style: theme.textTheme.bodyLarge),
        ],
        if (history.isNotEmpty) ...[
          const SizedBox(height: AppSpace.xl),
          Text('Historia', style: heading),
          const SizedBox(height: AppSpace.sm),
          Text(history, style: theme.textTheme.bodyLarge),
        ],
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= AppMeasure.expanded;
        final photo = BreedPhotoFrame(
          padding: wide
              ? const EdgeInsets.fromLTRB(
                  AppSpace.lg,
                  AppSpace.lg,
                  AppSpace.sm,
                  AppSpace.lg,
                )
              : const EdgeInsets.fromLTRB(
                  AppSpace.lg,
                  AppSpace.md,
                  AppSpace.lg,
                  0,
                ),
          child: BreedPhoto(
            name: breed.name,
            url: breed.imageUrl,
            heroTag: 'breed-photo-${breed.id}',
          ),
        );
        if (!wide) {
          return Column(
            children: [
              photo,
              Expanded(child: text),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 45, child: photo),
            Expanded(flex: 55, child: text),
          ],
        );
      },
    );
  }
}

class _MissingBreed extends StatelessWidget {
  const _MissingBreed();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Text(
          'Esta raza no está en el catálogo.',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
