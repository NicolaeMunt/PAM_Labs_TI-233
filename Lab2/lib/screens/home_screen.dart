import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../theme/app_colors.dart';
import '../widgets/doctor_photo.dart';
import 'appointment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> _favorites = {};

  void _openAppointment(Doctor doctor) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AppointmentScreen(doctor: doctor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const _Header(),
            const SizedBox(height: 20),
            const _SearchBar(),
            const SizedBox(height: 20),
            _AppointmentCard(onTap: () => _openAppointment(appointmentDoctor)),
            const SizedBox(height: 24),
            const _SectionTitle('Health Services'),
            const SizedBox(height: 12),
            const _HealthServicesRow(),
            const SizedBox(height: 24),
            const _SectionTitle('Nearby Doctor'),
            const SizedBox(height: 8),
            for (final doctor in nearbyDoctors)
              _NearbyDoctorTile(
                doctor: doctor,
                isFavorite: _favorites.contains(doctor.name),
                onFavorite: () => setState(() {
                  if (!_favorites.remove(doctor.name)) {
                    _favorites.add(doctor.name);
                  }
                }),
                onTap: () => _openAppointment(doctor),
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const DoctorPhoto(
          url: 'https://randomuser.me/api/portraits/men/11.jpg',
          size: 44,
          radius: 22,
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Jonathan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'May you always be healthy',
                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
              color: AppColors.textDark,
            ),
            Positioned(
              right: 12,
              top: 11,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.notification,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search something',
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
        suffixIcon: const Icon(Icons.tune, color: AppColors.textGrey),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AppointmentCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    const whiteText = TextStyle(color: Colors.white, fontSize: 13);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Teal card; its bottom is overlapped by the doctor card.
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [AppColors.primaryLight, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Appointment',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white, size: 20),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text('22 October, 2023', style: whiteText),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text('08:00 AM - 10.30 AM', style: whiteText),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_note,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  DoctorPhoto(url: upcomingDoctor.imageUrl, size: 36),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          upcomingDoctor.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          upcomingDoctor.specialty,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chat_outlined,
                    size: 20,
                    color: AppColors.textDark,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: EdgeInsets.zero,
            minimumSize: const Size(40, 30),
          ),
          child: const Text('See All', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}

class _HealthServicesRow extends StatelessWidget {
  const _HealthServicesRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final service in healthServices)
          Column(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  service.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                service.label,
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ],
          ),
      ],
    );
  }
}

class _NearbyDoctorTile extends StatelessWidget {
  final Doctor doctor;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const _NearbyDoctorTile({
    required this.doctor,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoctorPhoto(url: doctor.imageUrl, size: 44, radius: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${doctor.address} - ${doctor.distance} from you',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onFavorite,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: isFavorite ? AppColors.notification : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
