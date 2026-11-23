import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab3/core/error/failures.dart';
import 'package:lab3/data/models/appointment_details_model.dart';
import 'package:lab3/data/models/home_feed_model.dart';
import 'package:lab3/domain/entities/appointment_details.dart';
import 'package:lab3/domain/entities/home_feed.dart';
import 'package:lab3/domain/repositories/health_repository.dart';
import 'package:lab3/domain/usecases/filter_doctors.dart';
import 'package:lab3/domain/usecases/get_appointment_details.dart';
import 'package:lab3/domain/usecases/get_home_feed.dart';
import 'package:lab3/presentation/cubits/details/details_cubit.dart';
import 'package:lab3/presentation/cubits/home/home_cubit.dart';

import '../helpers.dart';

/// Repository fake: answers from the fixtures, or fails on demand.
class FakeRepository implements HealthRepository {
  final List<Failure?> feedFailures;
  final Failure? detailsFailure;
  int feedCalls = 0;

  FakeRepository({this.feedFailures = const [], this.detailsFailure});

  @override
  Future<HomeFeed> getHomeFeed() async {
    final failure = feedCalls < feedFailures.length
        ? feedFailures[feedCalls]
        : null;
    feedCalls++;
    if (failure != null) throw failure;
    return HomeFeedModel.fromJson(fixtureJson('feed.json')).toEntity();
  }

  @override
  Future<AppointmentDetails> getAppointmentDetails() async {
    if (detailsFailure != null) throw detailsFailure!;
    return AppointmentDetailsModel.fromJson(fixtureJson('feed_details.json'))
        .toEntity();
  }
}

void main() {
  List<String> ids(HomeState s) => s.visibleDoctors.map((d) => d.id).toList();

  group('HomeCubit', () {
    HomeCubit build(FakeRepository repo) =>
        HomeCubit(getHomeFeed: GetHomeFeed(repo));

    blocTest<HomeCubit, HomeState>(
      'Loading then Success with doctors nearest first',
      build: () => build(FakeRepository()),
      act: (c) => c.load(),
      expect: () => [
        isA<HomeState>().having((s) => s.status, 'status', HomeStatus.loading),
        isA<HomeState>()
            .having((s) => s.status, 'status', HomeStatus.success)
            .having(ids, 'doctors', ['doctor-001', 'doctor-002']),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'Failure from the API -> Error with its message',
      build: () =>
          build(FakeRepository(feedFailures: [const ServerFailure(503)])),
      act: (c) => c.load(),
      skip: 1,
      expect: () => [
        isA<HomeState>()
            .having((s) => s.status, 'status', HomeStatus.error)
            .having((s) => s.errorMessage, 'message', contains('503')),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'retry after an error succeeds',
      build: () =>
          build(FakeRepository(feedFailures: [const NetworkFailure()])),
      act: (c) async {
        await c.load();
        await c.load();
      },
      verify: (c) => expect(c.state.status, HomeStatus.success),
    );

    blocTest<HomeCubit, HomeState>(
      'search, service filter, favorites and sort',
      build: () => build(FakeRepository()),
      act: (c) async {
        await c.load();
        c.search('sonja');
        expect(ids(c.state), ['doctor-002']);
        c.search('');
        c.selectService('tooth');
        expect(ids(c.state), ['doctor-002']);
        c.selectService('eye');
        expect(c.state.status, HomeStatus.empty);
        c.clearFilters();
        c.toggleFavorite('doctor-001');
        c.setFavoritesOnly(true);
        expect(ids(c.state), ['doctor-001']);
        c.setFavoritesOnly(false);
        c.changeSort(DoctorSort.nameDesc);
        expect(ids(c.state), ['doctor-002', 'doctor-001']);
      },
    );

    test('failed refresh keeps the old data and rethrows', () async {
      final cubit = build(
        FakeRepository(feedFailures: [null, const NetworkFailure()]),
      );
      await cubit.load();
      await expectLater(cubit.refresh(), throwsA(isA<NetworkFailure>()));
      expect(cubit.state.status, HomeStatus.success);
      expect(cubit.state.isRefreshing, isFalse);
      await cubit.close();
    });
  });

  group('DetailsCubit', () {
    DetailsCubit build(FakeRepository repo) => DetailsCubit(
      getAppointmentDetails: GetAppointmentDetails(repo),
      bookingDelay: Duration.zero,
    );

    blocTest<DetailsCubit, DetailsState>(
      'loads details and preselects the API slots',
      build: () => build(FakeRepository()),
      act: (c) => c.load(),
      skip: 1,
      expect: () => [
        isA<DetailsState>()
            .having((s) => s.status, 'status', DetailsStatus.success)
            .having((s) => s.hourId, 'hour', '11am')
            .having((s) => s.dateId, 'date', 'sun-4'),
      ],
    );

    blocTest<DetailsCubit, DetailsState>(
      'Failure -> Error',
      build: () =>
          build(FakeRepository(detailsFailure: const ParsingFailure())),
      act: (c) => c.load(),
      skip: 1,
      expect: () => [
        isA<DetailsState>().having(
          (s) => s.status,
          'status',
          DetailsStatus.error,
        ),
      ],
    );

    blocTest<DetailsCubit, DetailsState>(
      'select slots, then book: submitting -> booked',
      build: () => build(FakeRepository()),
      act: (c) async {
        await c.load();
        c.selectHour('10am');
        c.selectDate('mon-5');
        await c.book();
      },
      skip: 4,
      expect: () => [
        isA<DetailsState>()
            .having((s) => s.booking, 'booking', BookingStatus.submitting)
            .having((s) => s.hourId, 'hour', '10am'),
        isA<DetailsState>()
            .having((s) => s.booking, 'booking', BookingStatus.booked)
            .having((s) => s.dateId, 'date', 'mon-5'),
      ],
    );

    test('cannot book before details load', () async {
      final cubit = build(FakeRepository());
      expect(cubit.state.canBook, isFalse);
      await cubit.book();
      expect(cubit.state.booking, BookingStatus.idle);
      await cubit.close();
    });
  });
}
