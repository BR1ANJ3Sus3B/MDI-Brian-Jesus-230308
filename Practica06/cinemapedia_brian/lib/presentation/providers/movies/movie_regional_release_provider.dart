import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/region/selected_region_provider.dart';
import 'package:cinemapedia/domain/entities/regional_release_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRegionalReleaseProvider =
    FutureProvider.family<RegionalReleaseInfo, int>((ref, movieId) {
  final region = ref.watch(selectedRegionProvider);
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getRegionalReleaseInfo(movieId, region.code);
});
