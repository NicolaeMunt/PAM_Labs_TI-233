import 'package:equatable/equatable.dart';

/// A doctor shown in the "Nearby Doctor" list.
class Doctor extends Equatable {
  final String id;
  final String name;
  final String specialty;

  /// Full text from the API, e.g. "3167 Durgan Shores - 500M from you".
  final String distanceLabel;
  final String avatarUrl;
  final bool isFavorite;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.distanceLabel,
    required this.avatarUrl,
    this.isFavorite = false,
  });

  /// Street part of [distanceLabel], e.g. "3167 Durgan Shores".
  String get address => distanceLabel.split(' - ').first.trim();

  /// Distance in meters, used to sort by "Nearest".
  double get distanceMeters => parseDistanceMeters(distanceLabel);

  /// Health service this doctor belongs to, worked out from the specialty
  /// (the API has no such field). Null when it matches none.
  String? get serviceId {
    final s = specialty.toLowerCase();
    if (s.contains('dent') || s.contains('tooth')) return 'tooth';
    if (s.contains('eye') || s.contains('ophthalm') || s.contains('optom')) {
      return 'eye';
    }
    if (s.contains('lung') || s.contains('pulmo') || s.contains('respir')) {
      return 'lungs';
    }
    if (RegExp(r'\b(ear|ent)\b').hasMatch(s) || s.contains('audio')) {
      return 'ear';
    }
    return null;
  }

  /// Reads "500M" or "1.2KM" out of a label like "... - 500M from you".
  /// Returns infinity when there is no distance, so those sort last.
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
  ];
}
