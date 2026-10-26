import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab3/logic/home/home_cubit.dart';

import 'helpers.dart';

void main() {
  List<String> ids(HomeState s) => s.visibleDoctors.map((d) => d.id).toList();

  group('load', () {
    blocTest<HomeCubit, HomeState>(
      'emits Loading then Success with favorites from JSON',
      build: () => HomeCubit(FakeHealthRepository.data(sampleData())),
      act: (c) => c.load(),
      expect: () => [
        isA<HomeState>().having((s) => s.status, 'status', HomeStatus.loading),
        isA<HomeState>()
            .having((s) => s.status, 'status', HomeStatus.success)
            .having(ids, 'sorted by distance', ['b', 'c', 'a'])
            .having((s) => s.favoriteIds, 'favorites', {'a'}),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits Empty when the JSON has no doctors',
      build: () =>
          HomeCubit(FakeHealthRepository.data(sampleData(doctors: []))),
      act: (c) => c.load(),
      skip: 1,
      expect: () => [
        isA<HomeState>()
            .having((s) => s.status, 'status', HomeStatus.empty)
            .having((s) => s.hasActiveFilters, 'filtered', false),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits Error with the message when loading fails',
      build: () => HomeCubit(FakeHealthRepository.failing('File missing')),
      act: (c) => c.load(),
      skip: 1,
      expect: () => [
        isA<HomeState>()
            .having((s) => s.status, 'status', HomeStatus.error)
            .having((s) => s.errorMessage, 'message', 'File missing'),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'retry after an error can succeed',
      build: () => HomeCubit(
        FakeHealthRepository([
          () => throw Exception('offline'),
          () => sampleData(),
        ]),
      ),
      act: (c) async {
        await c.load();
        await c.load();
      },
      verify: (c) {
        expect(c.state.status, HomeStatus.success);
        expect(c.state.errorMessage, isNull);
      },
    );
  });

  group('search, filter, sort', () {
    late HomeCubit cubit;

    setUp(() async {
      cubit = HomeCubit(FakeHealthRepository.data(sampleData()));
      await cubit.load();
    });

    tearDown(() => cubit.close());

    test('search matches name, specialty and address, ignoring case', () {
      cubit.search('dental');
      expect(ids(cubit.state), ['c']);
      cubit.search('  ELM ');
      expect(ids(cubit.state), ['b']);
      cubit.search('anna');
      expect(ids(cubit.state), ['a']);
    });

    test('no match gives Empty, clearFilters brings the list back', () {
      cubit.search('zzz');
      expect(cubit.state.status, HomeStatus.empty);
      expect(cubit.state.hasActiveFilters, isTrue);

      cubit.clearFilters();
      expect(cubit.state.status, HomeStatus.success);
      expect(cubit.state.query, '');
      expect(ids(cubit.state), hasLength(3));
    });

    test('service filter toggles on second tap', () {
      cubit.selectService('tooth');
      expect(ids(cubit.state), ['c', 'a']);
      cubit.selectService('tooth');
      expect(cubit.state.serviceId, isNull);
      expect(ids(cubit.state), hasLength(3));
    });

    test('filters combine', () {
      cubit.selectService('tooth');
      cubit.setFavoritesOnly(true);
      expect(ids(cubit.state), ['a']);
      cubit.search('bob');
      expect(cubit.state.status, HomeStatus.empty);
    });

    test('every sort option', () {
      final expected = {
        DoctorSort.nearest: ['b', 'c', 'a'],
        DoctorSort.rating: ['a', 'c', 'b'],
        DoctorSort.priceLow: ['b', 'c', 'a'],
        DoctorSort.priceHigh: ['a', 'c', 'b'],
        DoctorSort.name: ['a', 'c', 'b'],
      };
      expected.forEach((sort, order) {
        cubit.changeSort(sort);
        expect(ids(cubit.state), order, reason: sort.name);
      });
    });

    test('toggleFavorite adds and removes, favorites-only list follows', () {
      cubit.setFavoritesOnly(true);
      cubit.toggleFavorite('b');
      expect(cubit.state.favoriteIds, {'a', 'b'});
      expect(ids(cubit.state), ['b', 'a']);

      cubit.toggleFavorite('a');
      cubit.toggleFavorite('b');
      expect(cubit.state.favoriteIds, isEmpty);
      expect(cubit.state.status, HomeStatus.empty);
    });

    test('refresh keeps filters and favorites', () async {
      cubit.toggleFavorite('b');
      cubit.selectService('eye');
      await cubit.refresh();
      expect(cubit.state.isRefreshing, isFalse);
      expect(cubit.state.favoriteIds, {'a', 'b'});
      expect(ids(cubit.state), ['b']);
    });
  });

  test('refresh failure keeps old data and rethrows', () async {
    final cubit = HomeCubit(
      FakeHealthRepository([() => sampleData(), () => throw Exception('x')]),
    );
    await cubit.load();
    await expectLater(cubit.refresh(), throwsException);
    expect(cubit.state.status, HomeStatus.success);
    expect(cubit.state.visibleDoctors, hasLength(3));
    expect(cubit.state.isRefreshing, isFalse);
    await cubit.close();
  });
}
