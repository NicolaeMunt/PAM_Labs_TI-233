import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/appointment_details.dart';
import '../../data/models/doctor.dart';
import '../../logic/booking/booking_cubit.dart';
import '../../logic/home/home_cubit.dart';
import '../widgets/doctor_card.dart';
import '../widgets/favorite_button.dart';
import '../widgets/network_avatar.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_header.dart';
import '../widgets/slot_selector.dart';

/// Doctor page: info, payment, details text, hour/date pickers, booking.
class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  static Route<void> route(Doctor doctor) => MaterialPageRoute(
    settings: RouteSettings(name: '/doctor/${doctor.id}'),
    builder: (_) => DoctorDetailsScreen(doctor: doctor),
  );

  @override
  Widget build(BuildContext context) {
    final details = context.read<HomeCubit>().state.data!.appointmentDetails;

    return BlocProvider(
      create: (_) => BookingCubit(details),
      child: _DetailsView(doctor: doctor, details: details),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final Doctor doctor;
  final AppointmentDetails details;

  const _DetailsView({required this.doctor, required this.details});

  void _showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.read<BookingCubit>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(details.title),
        actions: [
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
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) => ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _DoctorSummary(
                doctor: doctor,
                details: details,
                onContact: (action) =>
                    _showSnack(context, '$action ${doctor.name}…'),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _StatsRow(doctor: doctor),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(title: details.detailsTitle),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(title: details.workingHours.title),
            ),
            const SizedBox(height: 10),
            SlotSelector(
              slots: details.workingHours.slots,
              selectedId: state.hourId,
              onSelected: booking.selectHour,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(title: details.dates.title),
            ),
            const SizedBox(height: 10),
            SlotSelector(
              slots: details.dates.slots,
              selectedId: state.dateId,
              onSelected: booking.selectDate,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: BlocConsumer<BookingCubit, BookingState>(
          listenWhen: (prev, next) =>
              prev.status != next.status && next.status == BookingStatus.booked,
          listener: (context, state) => _showSnack(
            context,
            'Appointment booked with ${doctor.name} on '
            '${details.dates.labelFor(state.dateId)} at '
            '${details.workingHours.labelFor(state.hourId)}',
          ),
          builder: (context, state) => PrimaryButton(
            label: state.status == BookingStatus.booked
                ? 'Booked'
                : details.bookLabel,
            isLoading: state.status == BookingStatus.submitting,
            onPressed: details.bookEnabled && state.canBook
                ? booking.book
                : null,
          ),
        ),
      ),
    );
  }
}

class _DoctorSummary extends StatelessWidget {
  final Doctor doctor;
  final AppointmentDetails details;
  final ValueChanged<String> onContact;

  const _DoctorSummary({
    required this.doctor,
    required this.details,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final price = doctor.price > 0 ? doctor.price : details.paymentAmount;

    return Row(
      children: [
        Hero(
          tag: 'doctor-photo-${doctor.id}',
          child: NetworkAvatar(
            url: doctor.avatarUrl,
            name: doctor.name,
            size: 104,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (details.canMessage)
                    ContactButton(
                      icon: Icons.chat_bubble_outline,
                      tooltip: 'Message',
                      onPressed: () => onContact('Messaging'),
                    ),
                  if (details.canCall) ...[
                    const SizedBox(width: 6),
                    ContactButton(
                      icon: Icons.call_outlined,
                      tooltip: 'Call',
                      onPressed: () => onContact('Calling'),
                    ),
                  ],
                  if (details.canVideoCall) ...[
                    const SizedBox(width: 6),
                    ContactButton(
                      icon: Icons.videocam_outlined,
                      tooltip: 'Video call',
                      onPressed: () => onContact('Video calling'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                doctor.specialty,
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
                    details.formatPrice(price),
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

/// Rating, experience and distance in three small boxes.
class _StatsRow extends StatelessWidget {
  final Doctor doctor;

  const _StatsRow({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            value: RatingLabel(rating: doctor.rating, fontSize: 14),
            label: '${doctor.reviews} reviews',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            value: _StatText('${doctor.experienceYears} yrs'),
            label: 'Experience',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            value: _StatText(
              doctor.shortDistance.isEmpty ? '—' : doctor.shortDistance,
            ),
            label: 'Distance',
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final Widget value;
  final String label;

  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          value,
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}

class _StatText extends StatelessWidget {
  final String text;

  const _StatText(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
  );
}
