import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Rounded doctor portrait loaded from the network, with an icon fallback
/// so the UI still renders when offline.
class DoctorPhoto extends StatelessWidget {
  final String url;
  final double size;
  final double radius;

  const DoctorPhoto({
    super.key,
    required this.url,
    required this.size,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: size,
          height: size,
          color: AppColors.surface,
          child: Icon(
            Icons.person,
            size: size * 0.6,
            color: AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}
