import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/home_models.dart';

/// Square "Health Services" button. Selected tiles filter the doctor list.
class ServiceTile extends StatelessWidget {
  final HealthService service;
  final bool selected;
  final VoidCallback? onTap;

  const ServiceTile({
    super.key,
    required this.service,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Bundled PNG from Lab 2, used while the SVG loads or if it fails.
    final fallback = Image.asset(
      service.fallbackAsset,
      width: 32,
      height: 32,
      errorBuilder: (_, _, _) =>
          const Icon(Icons.medical_services_outlined, color: AppColors.primary),
    );

    return Semantics(
      button: true,
      selected: selected,
      label: service.name,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: service.iconUrl.isEmpty
                  ? fallback
                  : SvgPicture.network(
                      service.iconUrl,
                      width: 32,
                      height: 32,
                      placeholderBuilder: (_) => fallback,
                      errorBuilder: (_, _, _) => fallback,
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              service.name,
              style: TextStyle(
                fontSize: 12,
                color: selected ? AppColors.primary : AppColors.textGrey,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
