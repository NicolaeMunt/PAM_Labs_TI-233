import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Shown while the JSON is loading.
class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({super.key, this.message = 'Loading doctors…'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.textGrey)),
        ],
      ),
    );
  }
}

/// Icon, title, message and an optional button. Base for Empty and Error.
class MessageView extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  const MessageView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.iconColor = AppColors.primary,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 34, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onAction,
              icon: Icon(actionIcon ?? Icons.refresh, size: 18),
              label: Text(actionLabel!),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Nothing to show: no doctors at all, or none match the filters.
class EmptyView extends StatelessWidget {
  final bool filtered;
  final VoidCallback? onClearFilters;

  const EmptyView({super.key, required this.filtered, this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    return filtered
        ? MessageView(
            icon: Icons.search_off_rounded,
            title: 'No doctors found',
            message: 'Try another name or specialty, or clear the filters.',
            actionLabel: 'Clear filters',
            actionIcon: Icons.filter_alt_off_outlined,
            onAction: onClearFilters,
          )
        : const MessageView(
            icon: Icons.person_search_outlined,
            title: 'No doctors yet',
            message: 'There are no doctors near you right now.',
          );
  }
}

/// Loading failed. Offers a retry.
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MessageView(
        icon: Icons.cloud_off_rounded,
        iconColor: AppColors.notification,
        title: 'Couldn\'t load data',
        message: message,
        actionLabel: 'Try again',
        onAction: onRetry,
      ),
    );
  }
}
