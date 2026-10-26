import 'package:equatable/equatable.dart';

/// The signed-in user shown in the home header.
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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    return UserProfile(
      name: name,
      greeting: json['greeting'] as String? ?? 'Hi, $name',
      subtitle: json['subtitle'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [name, greeting, subtitle, avatarUrl];
}

/// One of the round "Health Services" buttons (Tooth, Eye, ...).
class HealthService extends Equatable {
  final String id;
  final String name;
  final String iconUrl;

  const HealthService({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory HealthService.fromJson(Map<String, dynamic> json) => HealthService(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    iconUrl: json['iconUrl'] as String? ?? '',
  );

  /// Bundled icon used when [iconUrl] can't be loaded (e.g. offline).
  String get fallbackAsset => 'assets/images/$id.png';

  @override
  List<Object?> get props => [id, name, iconUrl];
}

/// The teal "Appointment" card on the home screen.
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

  factory UpcomingAppointment.fromJson(Map<String, dynamic> json) {
    final doctor = json['doctor'] as Map<String, dynamic>? ?? const {};
    return UpcomingAppointment(
      title: json['title'] as String? ?? 'Appointment',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      doctorName: doctor['name'] as String? ?? '',
      doctorSpecialty: doctor['specialty'] as String? ?? '',
      doctorAvatarUrl: doctor['avatarUrl'] as String? ?? '',
    );
  }

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
