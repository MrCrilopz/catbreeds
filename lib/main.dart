import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:catbreeds/app.dart';
import 'package:catbreeds/core/config/env.dart';
import 'package:catbreeds/core/network/api_client.dart';
import 'package:catbreeds/core/observability/app_bloc_observer.dart';
import 'package:catbreeds/features/breeds/data/datasources/breed_remote_data_source.dart';
import 'package:catbreeds/features/breeds/data/repositories/breed_repository_impl.dart';
import 'package:catbreeds/features/breeds/domain/repositories/breed_repository.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  final baseUrl = Env.catApiBaseUrl;
  final apiKey = Env.catApiKey;
  final BreedRepository? repository = baseUrl.isEmpty || apiKey.isEmpty
      ? null
      : BreedRepositoryImpl(
          BreedRemoteDataSourceImpl(
            createApiClient(baseUrl: baseUrl, apiKey: apiKey),
          ),
        );
  runApp(CatbreedsApp(repository: repository));
}
