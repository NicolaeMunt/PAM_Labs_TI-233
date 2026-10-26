import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/home_models.dart';
import 'network_avatar.dart';

/// Teal card with the next appointment and a white doctor card overlapping it.
class AppointmentCard extends StatelessWidget {
  final UpcomingAppointment appointment;
  final VoidCallback? onTap;

  const AppointmentCard({super.key, required this.appointment, this.onTap});

  @override
  Widget build(BuildContext context) {
    const whiteText = TextStyle(color: Colors.white, fontSize: 13);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [AppColors.primaryLight, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        appointment.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _IconText(
                            icon: Icons.calendar_today_outlined,
                            text: appointment.date,
                            style: whiteText,
                          ),
                          const SizedBox(height: 10),
                          _IconText(
                            icon: Icons.access_time,
                            text: appointment.time,
                            style: whiteText,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_note,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  NetworkAvatar(
                    url: appointment.doctorAvatarUrl,
                    name: appointment.doctorName,
                    size: 36,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          appointment.doctorSpecialty,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chat_outlined,
                    size: 20,
                    color: AppColors.textDark,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle style;

  const _IconText({
    required this.icon,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: style.color, size: 16),
        const SizedBox(width: 8),
        Flexible(child: Text(text, style: style)),
      ],
    );
  }
}
