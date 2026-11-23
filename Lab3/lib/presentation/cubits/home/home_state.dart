part of 'home_cubit.dart';

enum HomeStatus { loading, success, empty, error }

class HomeState extends Equatable {
  final HomeStatus status;

  /// Data from GET /feed. Null until the first request succeeds.
  final HomeFeed? feed;

  /// Doctors left after search, filters and sorting. This is what the list shows.
  final List<Doctor> visibleDoctors;

  final String query;

  /// Selected health service ("tooth", "eye", ...), or null for all.
  final String? serviceId;
  final bool favoritesOnly;
  final DoctorSort sort;
  final Set<String> favoriteIds;

  /// True while pull-to-refresh calls the API again over existing content.
  final bool isRefreshing;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.loading,
    this.feed,
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

  int get totalDoctors => feed?.doctors.length ?? 0;

  HomeState copyWith({
    HomeStatus? status,
    HomeFeed? feed,
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
      feed: feed ?? this.feed,
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
    feed,
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
