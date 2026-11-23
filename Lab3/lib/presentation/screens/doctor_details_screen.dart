import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/appointment_details.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/usecases/get_appointment_details.dart';
import '../cubits/details/details_cubit.dart';
import '../cubits/home/home_cubit.dart';
import '../widgets/favorite_button.dart';
import '../widgets/network_avatar.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_header.dart';
import '../widgets/slot_selector.dart';
import '../widgets/state_views.dart';

/// Appointment page. Its content comes from GET /feed/details.
///
/// Opened from the doctor list, it shows that [doctor]'s name and photo.
/// Opened from the appointment card ([doctor] is null), it shows the doctor
/// that the details endpoint describes.
class DoctorDetailsScreen extends StatelessWidget {
  final Doctor? doctor;

  const DoctorDetailsScreen({super.key, this.doctor});

  static Route<void> route({Doctor? doctor}) => MaterialPageRoute(
    settings: RouteSettings(name: '/details/${doctor?.id ?? 'appointment'}'),
    builder: (_) => DoctorDetailsScreen(doctor: doctor),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsCubit(
        getAppointmentDetails: context.read<GetAppointmentDetails>(),
      )..load(),
      child: _DetailsView(doctor: doctor),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final Doctor? doctor;

  const _DetailsView({required this.doctor});

  @override
  Widget build(BuildContext context) {
    final doctor = this.doctor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: BlocSelector<DetailsCubit, DetailsState, String>(
          selector: (s) => s.details?.title ?? 'Appointment',
          builder: (_, title) => Text(title),
        ),
        actions: [
          if (doctor != null)
            // Same favorites as the home list: both read HomeCubit.
            BlocSelector<HomeCubit, HomeState, bool>(
              selector: (state) => state.isFavorite(doctor.id),
              builder: (context, isFavorite) => FavoriteButton(
                isFavorite: isFavorite,
                onPressed: () =>
                    context.read<HomeCubit>().toggleFavorite(doctor.id),
              ),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<DetailsCubit, DetailsState>(
        buildWhen: (p, n) => p.status != n.status || p.details != n.details,
        builder: (context, state) => switch (state.status) {
          DetailsStatus.loading => const LoadingView(
            message: 'Loading appointment…',
          ),
          DetailsStatus.error => ErrorView(
            message: state.errorMessage ?? 'Unknown error.',
            onRetry: context.read<DetailsCubit>().load,
          ),
          DetailsStatus.success => _DetailsContent(
            doctor: doctor,
            details: state.details!,
          ),
        },
      ),
      bottomNavigationBar: const _BookButton(),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final Doctor? doctor;
  final AppointmentDetails details;

  const _DetailsContent({required this.doctor, required this.details});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DetailsCubit>();
    const hPad = EdgeInsets.symmetric(horizontal: 20);

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        Padding(
          padding: hPad,
          child: _DoctorSummary(doctor: doctor, details: details),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: hPad,
          child: SectionHeader(title: details.detailsTitle),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: hPad,
          child: Text(
            details.description,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: hPad,
          child: SectionHeader(title: details.workingHours.title),
        ),
        const SizedBox(height: 10),
        BlocSelector<DetailsCubit, DetailsState, String?>(
          selector: (s) => s.hourId,
          builder: (_, hourId) => SlotSelector(
            slots: details.workingHours.slots,
            selectedId: hourId,
            onSelected: cubit.selectHour,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: hPad,
          child: SectionHeader(title: details.dates.title),
        ),
        const SizedBox(height: 10),
        BlocSelector<DetailsCubit, DetailsState, String?>(
          selector: (s) => s.dateId,
          builder: (_, dateId) => SlotSelector(
            slots: details.dates.slots,
            selectedId: dateId,
            onSelected: cubit.selectDate,
          ),
        ),
      ],
    );
  }
}

class _BookButton extends StatelessWidget {
  const _BookButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailsCubit, DetailsState>(
      listenWhen: (p, n) =>
          p.booking != n.booking && n.booking == BookingStatus.booked,
      listener: (context, state) {
        final d = state.details!;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Appointment booked on ${d.dates.labelFor(state.dateId)} '
                'at ${d.workingHours.labelFor(state.hourId)}',
              ),
            ),
          );
      },
      builder: (context, state) {
        // Nothing to book until the details have loaded.
        if (state.details == null) return const SizedBox.shrink();
        return SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: PrimaryButton(
            label: state.booking == BookingStatus.booked
                ? 'Booked'
                : state.details!.bookLabel,
            isLoading: state.booking == BookingStatus.submitting,
            onPressed: state.canBook ? context.read<DetailsCubit>().book : null,
          ),
        );
      },
    );
  }
}

class _DoctorSummary extends StatelessWidget {
  final Doctor? doctor;
  final AppointmentDetails details;

  const _DoctorSummary({required this.doctor, required this.details});

  void _contact(BuildContext context, String action, String name) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$action $name…')));
  }

  @override
  Widget build(BuildContext context) {
    final doctor = this.doctor;
    final apiDoctor = details.doctor;
    final name = doctor?.name ?? apiDoctor.name;
    final subtitle = doctor?.specialty ?? apiDoctor.clinic;
    final photo = NetworkAvatar(
      url: doctor?.avatarUrl ?? apiDoctor.avatarUrl,
      name: name,
      size: 104,
    );

    return Row(
      children: [
        doctor == null
            ? photo
            : Hero(tag: 'doctor-photo-${doctor.id}', child: photo),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (apiDoctor.canMessage)
                    ContactButton(
                      icon: Icons.chat_bubble_outline,
                      tooltip: 'Message',
                      onPressed: () => _contact(context, 'Messaging', name),
                    ),
                  if (apiDoctor.canCall) ...[
                    const SizedBox(width: 6),
                    ContactButton(
                      icon: Icons.call_outlined,
                      tooltip: 'Call',
                      onPressed: () => _contact(context, 'Calling', name),
                    ),
                  ],
                  if (apiDoctor.canVideoCall) ...[
                    const SizedBox(width: 6),
                    ContactButton(
                      icon: Icons.videocam_outlined,
                      tooltip: 'Video call',
                      onPressed: () => _contact(context, 'Video calling', name),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: AppColors.primary),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      details.paymentLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  Text(
                    details.formattedPrice,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
