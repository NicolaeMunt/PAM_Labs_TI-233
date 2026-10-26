import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/appointment_details.dart';

/// Horizontally scrolling row of selectable pills (hours or dates).
class SlotSelector extends StatelessWidget {
  final List<TimeSlot> slots;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const SlotSelector({
    super.key,
    required this.slots,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: slots.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final slot = slots[i];
          final isSelected = slot.id == selectedId;
          return Semantics(
            button: true,
            selected: isSelected,
            child: GestureDetector(
              onTap: () => onSelected(slot.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 96,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  slot.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : AppColors.textDark,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
