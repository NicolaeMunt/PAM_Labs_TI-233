import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../logic/home/home_cubit.dart';

/// Bottom sheet with sorting, the favorites switch and the service filter.
/// Every change goes straight to [HomeCubit], so the list updates live.
class SortFilterSheet extends StatelessWidget {
  const SortFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const SortFilterSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final services = state.data?.services ?? const [];

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SheetTitle('Sort by'),
                for (final sort in DoctorSort.values)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(sort.label),
                    trailing: sort == state.sort
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    selected: sort == state.sort,
                    selectedColor: AppColors.primary,
                    onTap: () => cubit.changeSort(sort),
                  ),
                const Divider(height: 24),
                const _SheetTitle('Filter'),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Favorites only (${state.favoriteIds.length})'),
                  value: state.favoritesOnly,
                  activeThumbColor: AppColors.primary,
                  onChanged: cubit.setFavoritesOnly,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('All services'),
                      selected: state.serviceId == null,
                      onSelected: (_) => cubit.selectService(null),
                    ),
                    for (final s in services)
                      ChoiceChip(
                        label: Text(s.name),
                        selected: state.serviceId == s.id,
                        onSelected: (_) => cubit.selectService(s.id),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    TextButton(
                      onPressed: state.hasActiveFilters
                          ? cubit.clearFilters
                          : null,
                      child: const Text('Clear filters'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: Text(
                        'Show ${state.visibleDoctors.length} doctors',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SheetTitle extends StatelessWidget {
  final String text;

  const _SheetTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
