import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/doctor.dart';
import '../../logic/home/home_cubit.dart';
import '../widgets/appointment_card.dart';
import '../widgets/doctor_card.dart';
import '../widgets/home_header.dart';
import '../widgets/search_field.dart';
import '../widgets/section_header.dart';
import '../widgets/service_tile.dart';
import '../widgets/sort_filter_sheet.dart';
import '../widgets/state_views.dart';
import 'doctor_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          // Only rebuild the whole page when we switch between
          // "no data yet" and "have data".
          buildWhen: (prev, next) =>
              prev.status != next.status || prev.data != next.data,
          builder: (context, state) {
            if (state.data == null) {
              return switch (state.status) {
                HomeStatus.error => ErrorView(
                  message: state.errorMessage ?? 'Unknown error.',
                  onRetry: context.read<HomeCubit>().load,
                ),
                _ => const LoadingView(),
              };
            }
            return const _HomeContent();
          },
        ),
      ),
    );
  }
}

/// Shown once data is loaded (Success or Empty).
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  void _openDoctor(BuildContext context, Doctor doctor) {
    Navigator.of(context).push(DoctorDetailsScreen.route(doctor));
  }

  Future<void> _refresh(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.read<HomeCubit>().refresh();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Refresh failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final state = context.watch<HomeCubit>().state;
    final data = state.data!;
    const hPad = EdgeInsets.symmetric(horizontal: 20);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => _refresh(context),
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverList.list(
              children: [
                HomeHeader(
                  user: data.user,
                  hasUnreadNotifications: data.hasUnreadNotifications,
                  onNotificationsTap: () => ScaffoldMessenger.of(context)
                      .showSnackBar(
                        const SnackBar(content: Text('No new notifications')),
                      ),
                ),
                const SizedBox(height: 20),
                SearchField(
                  hint: data.searchHint,
                  value: state.query,
                  onChanged: cubit.search,
                  filtersActive:
                      state.favoritesOnly ||
                      state.serviceId != null ||
                      state.sort != DoctorSort.nearest,
                  onFilterTap: () => SortFilterSheet.show(context),
                ),
                const SizedBox(height: 20),
                AppointmentCard(
                  appointment: data.appointment,
                  onTap: () {
                    final doctor = data.doctorNamed(
                      data.appointment.doctorName,
                    );
                    if (doctor != null) _openDoctor(context, doctor);
                  },
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Health Services',
                  actionLabel: state.serviceId != null ? 'Clear' : null,
                  onAction: () => cubit.selectService(null),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final service in data.services)
                      ServiceTile(
                        service: service,
                        selected: state.serviceId == service.id,
                        onTap: () => cubit.selectService(service.id),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Nearby Doctor',
                  subtitle:
                      '${state.visibleDoctors.length} of ${state.totalDoctors}',
                  actionLabel: state.hasActiveFilters ? 'Clear all' : null,
                  onAction: cubit.clearFilters,
                ),
                const SizedBox(height: 4),
                _QuickFilters(state: state),
              ],
            ),
          ),
          if (state.status == HomeStatus.empty)
            SliverToBoxAdapter(
              child: EmptyView(
                filtered: state.hasActiveFilters,
                onClearFilters: cubit.clearFilters,
              ),
            )
          else
            SliverPadding(
              padding: hPad.copyWith(bottom: 24),
              sliver: SliverList.builder(
                itemCount: state.visibleDoctors.length,
                itemBuilder: (context, i) {
                  final doctor = state.visibleDoctors[i];
                  return DoctorCard(
                    key: ValueKey(doctor.id),
                    doctor: doctor,
                    isFavorite: state.isFavorite(doctor.id),
                    onFavoriteTap: () => cubit.toggleFavorite(doctor.id),
                    onTap: () => _openDoctor(context, doctor),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// "Favorites" chip and the sort menu right above the list.
class _QuickFilters extends StatelessWidget {
  final HomeState state;

  const _QuickFilters({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final service = state.data?.serviceById(state.serviceId);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            avatar: Icon(
              state.favoritesOnly ? Icons.favorite : Icons.favorite_border,
              size: 16,
              color: AppColors.notification,
            ),
            label: Text('Favorites (${state.favoriteIds.length})'),
            selected: state.favoritesOnly,
            showCheckmark: false,
            onSelected: cubit.setFavoritesOnly,
          ),
          if (service != null) ...[
            const SizedBox(width: 8),
            InputChip(
              label: Text(service.name),
              selected: true,
              showCheckmark: false,
              onDeleted: () => cubit.selectService(null),
            ),
          ],
          const SizedBox(width: 8),
          PopupMenuButton<DoctorSort>(
            tooltip: 'Sort doctors',
            initialValue: state.sort,
            onSelected: cubit.changeSort,
            itemBuilder: (_) => [
              for (final s in DoctorSort.values)
                CheckedPopupMenuItem(
                  value: s,
                  checked: s == state.sort,
                  child: Text(s.label),
                ),
            ],
            child: Chip(
              avatar: const Icon(Icons.sort, size: 16),
              label: Text('Sort: ${state.sort.label}'),
            ),
          ),
        ],
      ),
    );
  }
}
