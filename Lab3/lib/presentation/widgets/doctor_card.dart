import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/doctor.dart';
import 'favorite_button.dart';
import 'network_avatar.dart';

/// One row of the "Nearby Doctor" list.
class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'doctor-photo-${doctor.id}',
              child: NetworkAvatar.circle(
                url: doctor.avatarUrl,
                name: doctor.name,
                size: 48,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          doctor.specialty,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          doctor.distanceLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FavoriteButton(
              isFavorite: isFavorite,
              onPressed: onFavoriteTap,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
