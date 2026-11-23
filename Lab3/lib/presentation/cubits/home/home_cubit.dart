import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/doctor.dart';
import '../../../domain/entities/home_feed.dart';
import '../../../domain/usecases/filter_doctors.dart';
import '../../../domain/usecases/get_home_feed.dart';

part 'home_state.dart';

/// Home screen state. Gets data only through use cases, so it doesn't know
/// whether it comes from HTTP, a file or a test fake.
class HomeCubit extends Cubit<HomeState> {
  final GetHomeFeed getHomeFeed;
  final FilterDoctors filterDoctors;

  HomeCubit({
    required this.getHomeFeed,
    this.filterDoctors = const FilterDoctors(),
  }) : super(const HomeState());

  /// First load: full-screen Loading, then Success / Empty / Error.
  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: () => null));
    try {
      final feed = await getHomeFeed();
      final favorites = {
        for (final d in feed.doctors)
          if (d.isFavorite) d.id,
      };
      _emitFiltered(state.copyWith(feed: feed, favoriteIds: favorites));
    } on Failure catch (f) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: () => f.message),
      );
    }
  }

  /// Pull-to-refresh: calls the API again, keeps content, filters and
  /// favorites on screen. Rethrows the [Failure] so the screen can report it.
  Future<void> refresh() async {
    if (state.feed == null) return load();
    emit(state.copyWith(isRefreshing: true));
    try {
      final feed = await getHomeFeed();
      final ids = feed.doctors.map((d) => d.id).toSet();
      _emitFiltered(
        state.copyWith(
          feed: feed,
          isRefreshing: false,
          favoriteIds: state.favoriteIds.intersection(ids),
        ),
      );
    } on Failure {
      emit(state.copyWith(isRefreshing: false));
      rethrow;
    }
  }

  void search(String query) {
    if (query == state.query) return;
    _emitFiltered(state.copyWith(query: query));
  }

  /// Selects a health service, or clears it if it's already selected.
  void selectService(String? serviceId) {
    final next = serviceId == state.serviceId ? null : serviceId;
    _emitFiltered(state.copyWith(serviceId: () => next));
  }

  void setFavoritesOnly(bool value) =>
      _emitFiltered(state.copyWith(favoritesOnly: value));

  void changeSort(DoctorSort sort) => _emitFiltered(state.copyWith(sort: sort));

  /// Favorites are kept in the app only: the API has no endpoint to save them.
  void toggleFavorite(String doctorId) {
    final favorites = Set<String>.of(state.favoriteIds);
    if (!favorites.remove(doctorId)) favorites.add(doctorId);
    _emitFiltered(state.copyWith(favoriteIds: favorites));
  }

  void clearFilters() => _emitFiltered(
    state.copyWith(query: '', serviceId: () => null, favoritesOnly: false),
  );

  /// Recomputes the visible list and picks Success or Empty.
  void _emitFiltered(HomeState next) {
    final feed = next.feed;
    if (feed == null) return emit(next);

    final visible = filterDoctors(
      doctors: feed.doctors,
      query: next.query,
      serviceId: next.serviceId,
      favoritesOnly: next.favoritesOnly,
      favoriteIds: next.favoriteIds,
      sort: next.sort,
    );

    emit(
      next.copyWith(
        visibleDoctors: visible,
        status: visible.isEmpty ? HomeStatus.empty : HomeStatus.success,
        errorMessage: () => null,
      ),
    );
  }
}
