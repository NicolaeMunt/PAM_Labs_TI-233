import 'package:equatable/equatable.dart';

import 'doctor.dart';

/// Everything the home screen needs, from GET /feed.
class HomeFeed extends Equatable {
  final UserProfile user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final UpcomingAppointment appointment;
  final List<HealthService> services;
  final List<Doctor> doctors;

  const HomeFeed({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.services,
    required this.doctors,
  });

  HealthService? serviceById(String? id) =>
      services.where((s) => s.id == id).firstOrNull;

  @override
  List<Object?> get props => [
    user,
    hasUnreadNotifications,
    searchHint,
    appointment,
    services,
    doctors,
  ];
}

class UserProfile extends Equatable {
  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;

  const UserProfile({
    required this.name,
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, greeting, subtitle, avatarUrl];
}

/// One of the "Health Services" buttons (Tooth, Eye, ...).
class HealthService extends Equatable {
  final String id;
  final String name;
  final String iconUrl;

  const HealthService({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  @override
  List<Object?> get props => [id, name, iconUrl];
}

/// The teal "Appointment" card.
class UpcomingAppointment extends Equatable {
  final String title;
  final String date;
  final String time;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorAvatarUrl;

  const UpcomingAppointment({
    required this.title,
    required this.date,
    required this.time,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorAvatarUrl,
  });

  @override
  List<Object?> get props => [
    title,
    date,
    time,
    doctorName,
    doctorSpecialty,
    doctorAvatarUrl,
  ];
}
