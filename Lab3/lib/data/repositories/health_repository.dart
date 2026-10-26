import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/health_data.dart';

/// Thrown when the JSON file can't be read or has the wrong shape.
class HealthDataException implements Exception {
  final String message;

  const HealthDataException(this.message);

  @override
  String toString() => message;
}

/// Where the app gets its data from. The cubit only knows this interface,
/// so tests can pass a fake instead of reading the real asset.
abstract interface class HealthRepository {
  Future<HealthData> loadHealthData();
}

/// Reads `assets/data/health_data.json` from the app bundle.
class AssetHealthRepository implements HealthRepository {
  static const defaultPath = 'assets/data/health_data.json';

  final AssetBundle _bundle;
  final String path;

  /// Artificial delay so the Loading state is visible, like a network call.
  final Duration latency;

  AssetHealthRepository({
    AssetBundle? bundle,
    this.path = defaultPath,
    this.latency = const Duration(milliseconds: 900),
  }) : _bundle = bundle ?? rootBundle;

  @override
  Future<HealthData> loadHealthData() async {
    final String raw;
    try {
      // Both futures run at once; we wait for the slower one.
      final results = await Future.wait([
        _bundle.loadString(path, cache: false),
        Future<void>.delayed(latency),
      ]);
      raw = results.first as String;
    } catch (_) {
      throw HealthDataException('Could not read $path.');
    }

    try {
      // Decode and map on a background isolate so the UI stays smooth.
      return await compute(_parseHealthData, raw);
    } catch (_) {
      throw const HealthDataException('The data file has an invalid format.');
    }
  }
}

HealthData _parseHealthData(String raw) =>
    HealthData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
