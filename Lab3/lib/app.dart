import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'injection.dart';
import 'presentation/cubits/home/home_cubit.dart';
import 'presentation/screens/home_screen.dart';

class HealthApp extends StatelessWidget {
  final AppDependencies dependencies;

  const HealthApp({super.key, required this.dependencies});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      // Use cases are available to every screen via context.read<...>().
      providers: [
        RepositoryProvider.value(value: dependencies.getHomeFeed),
        RepositoryProvider.value(value: dependencies.getAppointmentDetails),
        RepositoryProvider.value(value: dependencies.httpClient),
      ],
      // Above MaterialApp so home, details and the filter sheet share
      // the same favorites and filters.
      child: BlocProvider(
        create: (_) => HomeCubit(getHomeFeed: dependencies.getHomeFeed)..load(),
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
