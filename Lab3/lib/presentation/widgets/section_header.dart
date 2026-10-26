import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Bold section title with an optional action on the right ("See All", "Clear").
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 8),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: const Size(40, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(actionLabel!, style: const TextStyle(fontSize: 12)),
          ),
      ],
    );
  }
}
