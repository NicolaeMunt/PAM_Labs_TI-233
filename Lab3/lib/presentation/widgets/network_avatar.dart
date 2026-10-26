import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Rounded photo loaded from a URL, with a grey placeholder while it loads
/// and the person's initials if it fails (e.g. no internet).
class NetworkAvatar extends StatelessWidget {
  final String url;
  final String name;
  final double size;
  final double radius;

  const NetworkAvatar({
    super.key,
    required this.url,
    required this.name,
    required this.size,
    this.radius = 8,
  });

  /// Circle variant used in lists and the header.
  const NetworkAvatar.circle({
    super.key,
    required this.url,
    required this.name,
    required this.size,
  }) : radius = size / 2;

  @override
  Widget build(BuildContext context) {
    final fallback = _Initials(name: name, size: size);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox.square(
        dimension: size,
        child: url.isEmpty
            ? fallback
            : Image.network(
                url,
                fit: BoxFit.cover,
                // Keep faces in frame when a tall photo is cropped to a square.
                alignment: Alignment.topCenter,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const ColoredBox(color: AppColors.surface),
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  final String name;
  final double size;

  const _Initials({required this.name, required this.size});

  String get _initials {
    final parts = name
        .replaceAll(RegExp(r'^Dr\.?\s*', caseSensitive: false), '')
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}
