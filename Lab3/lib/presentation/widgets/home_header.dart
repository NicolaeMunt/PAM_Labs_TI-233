import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/home_models.dart';
import 'network_avatar.dart';

/// "Hi, Jonathan" row with the user's photo and the notifications bell.
class HomeHeader extends StatelessWidget {
  final UserProfile user;
  final bool hasUnreadNotifications;
  final VoidCallback? onNotificationsTap;

  const HomeHeader({
    super.key,
    required this.user,
    required this.hasUnreadNotifications,
    this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NetworkAvatar.circle(url: user.avatarUrl, name: user.name, size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.greeting,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                user.subtitle,
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: onNotificationsTap,
          icon: Badge(
            isLabelVisible: hasUnreadNotifications,
            smallSize: 8,
            backgroundColor: AppColors.notification,
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
