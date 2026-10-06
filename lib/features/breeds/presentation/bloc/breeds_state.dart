import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:equatable/equatable.dart';

sealed class BreedsState extends Equatable {
  const BreedsState();

  @override
  List<Object?> get props => [];
}

final class BreedsInitial extends BreedsState {
  const BreedsInitial();
}

final class BreedsLoading extends BreedsState {
  const BreedsLoading();
}

final class BreedsReady extends BreedsState {
  const BreedsReady({
    required this.catalog,
    required this.query,
    required this.visible,
    this.revision = 0,
  });

  final List<Breed> catalog;
  final String query;
  final List<Breed> visible;
  final int revision;

  @override
  List<Object?> get props => [catalog, query, visible, revision];
}

final class BreedsFailure extends BreedsState {
  const BreedsFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
