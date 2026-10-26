import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Heart icon that pops a little when toggled.
class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;
  final double size;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isFavorite),
          size: size,
          color: isFavorite ? AppColors.notification : AppColors.textGrey,
        ),
      ),
    );
  }
}
