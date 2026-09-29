import 'package:flutter/material.dart';

/// Rounded portrait loaded from the app's bundled assets.
class DoctorPhoto extends StatelessWidget {
  final String path;
  final double size;
  final double radius;

  const DoctorPhoto({
    super.key,
    required this.path,
    required this.size,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        // Keep faces in frame when a tall photo is cropped to a square.
        alignment: Alignment.topCenter,
      ),
    );
  }
}
