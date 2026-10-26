import 'package:equatable/equatable.dart';

import 'appointment_details.dart';
import 'doctor.dart';
import 'home_models.dart';

/// Everything loaded from `assets/data/health_data.json`.
class HealthData extends Equatable {
  final UserProfile user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final UpcomingAppointment appointment;
  final List<HealthService> services;
  final List<Doctor> doctors;
  final AppointmentDetails appointmentDetails;

  const HealthData({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.services,
    required this.doctors,
    required this.appointmentDetails,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) {
    final home = json['homeScreen'] as Map<String, dynamic>;
    final notifications =
        home['notifications'] as Map<String, dynamic>? ?? const {};
    final search = home['search'] as Map<String, dynamic>? ?? const {};

    return HealthData(
      user: UserProfile.fromJson(home['user'] as Map<String, dynamic>),
      hasUnreadNotifications: notifications['hasUnread'] as bool? ?? false,
      searchHint: search['hint'] as String? ?? 'Search',
      appointment: UpcomingAppointment.fromJson(
        home['appointment'] as Map<String, dynamic>,
      ),
      services: (home['healthServices'] as List<dynamic>? ?? const [])
          .map((e) => HealthService.fromJson(e as Map<String, dynamic>))
          .toList(),
      doctors: (home['nearbyDoctors'] as List<dynamic>? ?? const [])
          .map((e) => Doctor.fromJson(e as Map<String, dynamic>))
          .toList(),
      appointmentDetails: AppointmentDetails.fromJson(
        json['appointmentDetails'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  /// Doctor with this exact name, if any (used by the appointment card).
  Doctor? doctorNamed(String name) =>
      doctors.where((d) => d.name == name).firstOrNull;

  /// Health service with this id, if any.
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
    appointmentDetails,
  ];
}
