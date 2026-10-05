import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/domain/filter_breeds.dart';
import 'package:catbreeds/features/breeds/domain/repositories/breed_repository.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_event.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class BreedsBloc extends Bloc<BreedsEvent, BreedsState> {
  BreedsBloc(this._repository) : super(const BreedsInitial()) {
    on<BreedsRequested>(_onRequested);
    on<BreedQueryChanged>(_onQueryChanged);
  }

  final BreedRepository _repository;

  Future<void> _onRequested(
    BreedsRequested event,
    Emitter<BreedsState> emit,
  ) async {
    final query = switch (state) {
      BreedsReady(:final query) => query,
      _ => '',
    };
    emit(const BreedsLoading());

    try {
      final catalog = await _repository.fetchBreeds();
      emit(
        BreedsReady(
          catalog: catalog,
          query: query,
          visible: filterBreeds(catalog, query),
        ),
      );
    } on Failure catch (failure) {
      emit(BreedsFailure(failure));
    }
  }

  void _onQueryChanged(BreedQueryChanged event, Emitter<BreedsState> emit) {
    final current = state;
    if (current is! BreedsReady) {
      return;
    }

    emit(
      BreedsReady(
        catalog: current.catalog,
        query: event.query,
        visible: filterBreeds(current.catalog, event.query),
      ),
    );
  }
}
