import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/doctor.dart';
import '../../data/models/health_data.dart';
import '../../data/repositories/health_repository.dart';

part 'home_state.dart';

/// Loads the JSON data and owns search, filters, sorting and favorites.
class HomeCubit extends Cubit<HomeState> {
  final HealthRepository _repository;

  HomeCubit(this._repository) : super(const HomeState());

  /// First load: shows the full-screen Loading state, then Success/Empty/Error.
  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: () => null));
    try {
      final data = await _repository.loadHealthData();
      final favorites = {
        for (final d in data.doctors)
          if (d.isFavorite) d.id,
      };
      _emitFiltered(state.copyWith(data: data, favoriteIds: favorites));
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: () => e is HealthDataException
              ? e.message
              : 'Something went wrong while loading doctors.',
        ),
      );
    }
  }

  /// Pull-to-refresh: reloads the JSON but keeps the current content,
  /// filters and favorites on screen while it runs.
  Future<void> refresh() async {
    if (state.data == null) return load();
    emit(state.copyWith(isRefreshing: true));
    try {
      final data = await _repository.loadHealthData();
      final ids = data.doctors.map((d) => d.id).toSet();
      _emitFiltered(
        state.copyWith(
          data: data,
          isRefreshing: false,
          favoriteIds: state.favoriteIds.intersection(ids),
        ),
      );
    } catch (_) {
      // Keep showing the old data; the screen reports the failure.
      emit(state.copyWith(isRefreshing: false));
      rethrow;
    }
  }

  void search(String query) {
    if (query == state.query) return;
    _emitFiltered(state.copyWith(query: query));
  }

  /// Taps on a health service: selects it, or clears it if already selected.
  void selectService(String? serviceId) {
    final next = serviceId == state.serviceId ? null : serviceId;
    _emitFiltered(state.copyWith(serviceId: () => next));
  }

  void setFavoritesOnly(bool value) =>
      _emitFiltered(state.copyWith(favoritesOnly: value));

  void changeSort(DoctorSort sort) => _emitFiltered(state.copyWith(sort: sort));

  void toggleFavorite(String doctorId) {
    final favorites = Set<String>.of(state.favoriteIds);
    if (!favorites.remove(doctorId)) favorites.add(doctorId);
    _emitFiltered(state.copyWith(favoriteIds: favorites));
  }

  /// Resets search, service and favorites filters (sorting stays).
  void clearFilters() => _emitFiltered(
    state.copyWith(query: '', serviceId: () => null, favoritesOnly: false),
  );

  /// Recomputes [HomeState.visibleDoctors] and picks Success or Empty.
  void _emitFiltered(HomeState next) {
    final data = next.data;
    if (data == null) return emit(next);

    final visible = applyFilters(
      doctors: data.doctors,
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

  /// Pure function, so the filtering rules are easy to unit test.
  static List<Doctor> applyFilters({
    required List<Doctor> doctors,
    String query = '',
    String? serviceId,
    bool favoritesOnly = false,
    Set<String> favoriteIds = const {},
    DoctorSort sort = DoctorSort.nearest,
  }) {
    final q = query.trim().toLowerCase();

    final result = doctors.where((d) {
      if (serviceId != null && d.serviceId != serviceId) return false;
      if (favoritesOnly && !favoriteIds.contains(d.id)) return false;
      if (q.isEmpty) return true;
      return d.name.toLowerCase().contains(q) ||
          d.specialty.toLowerCase().contains(q) ||
          d.address.toLowerCase().contains(q);
    }).toList();

    int byName(Doctor a, Doctor b) =>
        a.name.toLowerCase().compareTo(b.name.toLowerCase());

    result.sort(switch (sort) {
      DoctorSort.nearest => (a, b) {
        final c = a.distanceMeters.compareTo(b.distanceMeters);
        return c != 0 ? c : byName(a, b);
      },
      DoctorSort.rating => (a, b) {
        final c = b.rating.compareTo(a.rating);
        return c != 0 ? c : b.reviews.compareTo(a.reviews);
      },
      DoctorSort.priceLow => (a, b) {
        final c = a.price.compareTo(b.price);
        return c != 0 ? c : byName(a, b);
      },
      DoctorSort.priceHigh => (a, b) {
        final c = b.price.compareTo(a.price);
        return c != 0 ? c : byName(a, b);
      },
      DoctorSort.name => byName,
    });

    return result;
  }
}
