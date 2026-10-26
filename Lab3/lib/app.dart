import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/health_repository.dart';
import 'logic/home/home_cubit.dart';
import 'presentation/screens/home_screen.dart';

class HealthApp extends StatelessWidget {
  final HealthRepository repository;

  const HealthApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      // Provided above MaterialApp so every screen (home, details, the
      // filter sheet) shares the same favorites and filters.
      child: BlocProvider(
        create: (_) => HomeCubit(repository)..load(),
        child: MaterialApp(
          title: 'Health Appointments',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
