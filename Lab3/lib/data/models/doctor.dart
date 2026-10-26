import 'package:equatable/equatable.dart';

/// A doctor from the "nearbyDoctors" list in the JSON file.
class Doctor extends Equatable {
  final String id;
  final String name;
  final String specialty;

  /// Text as written in the JSON, e.g. "3167 Durgan Shores - 500M from you".
  final String distanceLabel;

  /// Street part of [distanceLabel], e.g. "3167 Durgan Shores".
  final String address;

  /// Distance parsed from [distanceLabel], used for sorting by "Nearest".
  final double distanceMeters;

  final String avatarUrl;

  /// Favorite flag stored in the JSON. The live value is kept by the cubit.
  final bool isFavorite;

  /// Id of the health service this doctor belongs to ("tooth", "eye", ...).
  final String serviceId;
  final double rating;
  final int reviews;
  final int experienceYears;
  final double price;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.distanceLabel,
    required this.address,
    required this.distanceMeters,
    required this.avatarUrl,
    this.isFavorite = false,
    this.serviceId = '',
    this.rating = 0,
    this.reviews = 0,
    this.experienceYears = 0,
    this.price = 0,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    final label = json['distance'] as String? ?? '';
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String? ?? '',
      distanceLabel: label,
      address: label.split(' - ').first.trim(),
      distanceMeters: parseDistanceMeters(label),
      avatarUrl: json['avatarUrl'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      serviceId: json['serviceId'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviews: (json['reviews'] as num?)?.toInt() ?? 0,
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Short distance for the UI, e.g. "500 m" or "1.2 km".
  String get shortDistance {
    if (distanceMeters == double.infinity) return '';
    if (distanceMeters < 1000) return '${distanceMeters.round()} m';
    return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
  }

  /// Reads "500M" or "1.2KM" out of a label like "... - 500M from you".
  /// Returns infinity when no distance is found, so those doctors sort last.
  static double parseDistanceMeters(String label) {
    final match = RegExp(
      r'(\d+(?:[.,]\d+)?)\s*(KM|M)\b',
      caseSensitive: false,
    ).firstMatch(label);
    if (match == null) return double.infinity;
    final value = double.parse(match.group(1)!.replaceAll(',', '.'));
    return match.group(2)!.toUpperCase() == 'KM' ? value * 1000 : value;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    specialty,
    distanceLabel,
    avatarUrl,
    isFavorite,
    serviceId,
    rating,
    reviews,
    experienceYears,
    price,
  ];
}
