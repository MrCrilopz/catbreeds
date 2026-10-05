import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/data/mappers/breed_mapper.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:dio/dio.dart';

abstract interface class BreedRemoteDataSource {
  Future<List<Breed>> fetchBreeds();
}

final class BreedRemoteDataSourceImpl implements BreedRemoteDataSource {
  BreedRemoteDataSourceImpl(this._client);

  final Dio _client;

  @override
  Future<List<Breed>> fetchBreeds() async {
    try {
      final response = await _client.get<Object?>('/v1/breeds');
      return mapBreeds(response.data);
    } on DioException catch (error) {
      throw failureFromDio(error);
    }
  }
}

Failure failureFromDio(DioException error) {
  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.connectionError => Failure.network,
    DioExceptionType.badResponse => Failure.server,
    DioExceptionType.badCertificate ||
    DioExceptionType.cancel ||
    DioExceptionType.unknown => Failure.unexpected,
  };
}
