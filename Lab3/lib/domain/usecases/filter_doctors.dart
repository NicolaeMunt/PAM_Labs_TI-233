import '../entities/doctor.dart';

/// Ways the doctor list can be ordered.
enum DoctorSort {
  nearest('Nearest'),
  nameAsc('Name A–Z'),
  nameDesc('Name Z–A');

  final String label;

  const DoctorSort(this.label);
}

/// Business rule for search, filters and sorting. Pure Dart, no I/O.
class FilterDoctors {
  const FilterDoctors();

  List<Doctor> call({
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
      DoctorSort.nameAsc => byName,
      DoctorSort.nameDesc => (a, b) => byName(b, a),
    });

    return result;
  }
}
