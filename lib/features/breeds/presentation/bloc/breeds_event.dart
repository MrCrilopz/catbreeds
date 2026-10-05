sealed class BreedsEvent {
  const BreedsEvent();
}

final class BreedsRequested extends BreedsEvent {
  const BreedsRequested();
}

final class BreedQueryChanged extends BreedsEvent {
  const BreedQueryChanged(this.query);

  final String query;
}
