part of 'home_cubit.dart';

enum HomeStatus { loading, success, empty, error }

/// Ways the doctor list can be ordered.
enum DoctorSort {
  nearest('Nearest'),
  rating('Top rated'),
  priceLow('Price: low to high'),
  priceHigh('Price: high to low'),
  name('Name A–Z');

  final String label;

  const DoctorSort(this.label);
}

class HomeState extends Equatable {
  final HomeStatus status;

  /// Everything loaded from the JSON. Null until the first load succeeds.
  final HealthData? data;

  /// Doctors left after search, filters and sorting. This is what the list shows.
  final List<Doctor> visibleDoctors;

  final String query;

  /// Selected health service ("tooth", "eye", ...), or null for all.
  final String? serviceId;
  final bool favoritesOnly;
  final DoctorSort sort;
  final Set<String> favoriteIds;

  /// True while pull-to-refresh reloads the JSON over existing content.
  final bool isRefreshing;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.loading,
    this.data,
    this.visibleDoctors = const [],
    this.query = '',
    this.serviceId,
    this.favoritesOnly = false,
    this.sort = DoctorSort.nearest,
    this.favoriteIds = const {},
    this.isRefreshing = false,
    this.errorMessage,
  });

  bool isFavorite(String doctorId) => favoriteIds.contains(doctorId);

  /// True when something narrows the list, so "Empty" means "no match".
  bool get hasActiveFilters =>
      query.trim().isNotEmpty || serviceId != null || favoritesOnly;

  int get totalDoctors => data?.doctors.length ?? 0;

  HomeState copyWith({
    HomeStatus? status,
    HealthData? data,
    List<Doctor>? visibleDoctors,
    String? query,
    String? Function()? serviceId,
    bool? favoritesOnly,
    DoctorSort? sort,
    Set<String>? favoriteIds,
    bool? isRefreshing,
    String? Function()? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      visibleDoctors: visibleDoctors ?? this.visibleDoctors,
      query: query ?? this.query,
      serviceId: serviceId != null ? serviceId() : this.serviceId,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      sort: sort ?? this.sort,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    data,
    visibleDoctors,
    query,
    serviceId,
    favoritesOnly,
    sort,
    favoriteIds,
    isRefreshing,
    errorMessage,
  ];
}
