import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/region/selected_region_provider.dart';

// Este repositorio es inmutable
final actorsRepositoryProvider = Provider((ref) {
  final region = ref.watch(selectedRegionProvider);
  return ActorRepositoryImpl(ActorMovieDbDatasource(region));
});
