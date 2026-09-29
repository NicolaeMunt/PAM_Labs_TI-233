import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../theme/app_colors.dart';
import '../widgets/doctor_photo.dart';

class AppointmentScreen extends StatefulWidget {
  final Doctor doctor;

  const AppointmentScreen({super.key, required this.doctor});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  static const _hours = [
    '10.00 AM',
    '11.00 AM',
    '12.00 PM',
    '01.00 PM',
    '02.00 PM',
  ];
  static const _dates = ['Sun 4', 'Mon 5', 'Tue 6', 'Wed 7', 'Thu 8'];

  static const _details =
      'Worem ipsum dolor sit amet, consectetur adipiscing elit. Nunc '
      'vulputate libero et velit interdum, ac aliquet odio mattis. Class '
      'aptent taciti sociosqu ad litora torquent per conubia nostra, per '
      'inceptos himenaeos. Curabitur tempus urna at turpis condimentum '
      'lobortis. Ut commodo efficitur neque. Ut diam quam, semper iaculis '
      'condimentum ac, vestibulum eu nisl.';

  int _selectedHour = 1;
  int _selectedDate = 0;

  void _book() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Appointment booked with ${widget.doctor.name} on '
          '${_dates[_selectedDate]} at ${_hours[_selectedHour]}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Appointment',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 0, 24),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _DoctorSummary(doctor: doctor),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: _SectionTitle('Details', showSeeAll: false),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              _details,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textGrey,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: _SectionTitle('Working Hours'),
          ),
          const SizedBox(height: 10),
          _ChipSelector(
            options: _hours,
            selected: _selectedHour,
            onSelected: (i) => setState(() => _selectedHour = i),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: _SectionTitle('Date'),
          ),
          const SizedBox(height: 10),
          _ChipSelector(
            options: _dates,
            selected: _selectedDate,
            onSelected: (i) => setState(() => _selectedDate = i),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: _book,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Book an Appointment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class _DoctorSummary extends StatelessWidget {
  final Doctor doctor;

  const _DoctorSummary({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DoctorPhoto(path: doctor.imagePath, size: 104),
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const _ContactButton(Icons.chat_bubble_outline),
                  const SizedBox(width: 6),
                  const _ContactButton(Icons.call_outlined),
                  const SizedBox(width: 6),
                  const _ContactButton(Icons.videocam_outlined),
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
                  const Expanded(
                    child: Text(
                      'Payment',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  Text(
                    '\$${doctor.price.toStringAsFixed(2)}',
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

class _ContactButton extends StatelessWidget {
  final IconData icon;

  const _ContactButton(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 14, color: AppColors.primary),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool showSeeAll;

  const _SectionTitle(this.title, {this.showSeeAll = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        if (showSeeAll)
          const Text(
            'See All',
            style: TextStyle(fontSize: 12, color: AppColors.textDark),
          ),
      ],
    );
  }
}

/// Horizontally scrolling row of selectable pills (hours / dates).
class _ChipSelector extends StatelessWidget {
  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelected;

  const _ChipSelector({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 20),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final isSelected = i == selected;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                options[i],
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? Colors.white : AppColors.textDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
