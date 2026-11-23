# Lab 4 – REST API, JSON Serialization & Clean Architecture

The health appointment app from Labs 2–3, same design, now loading all its
data from a REST API (variant **v2**) over HTTP.

| Endpoint | Used for |
|---|---|
| `GET https://test-api-jlbn.onrender.com/lab2026/v2/feed` | Home screen: user, appointment card, health services, nearby doctors |
| `GET https://test-api-jlbn.onrender.com/lab2026/v2/feed/details` | Details screen: payment, description, working hours, dates, booking button |

## Architecture

```
lib/
  main.dart, app.dart, injection.dart   start-up and dependency wiring
  core/
    network/   ApiClient (http GET + status check + JSON decode), ApiConfig (base URL, timeout)
    error/     exceptions.dart (Data layer), failures.dart (seen by Domain/UI)
    theme/
  domain/                      pure Dart, knows nothing about HTTP or Flutter UI
    entities/                  Doctor, HomeFeed, AppointmentDetails, ...
    repositories/              HealthRepository (abstract contract)
    usecases/                  GetHomeFeed, GetAppointmentDetails, FilterDoctors
  data/
    models/                    DTOs with @JsonSerializable + generated *.g.dart, toEntity()
    datasources/               HealthRemoteDataSource (calls the API, returns DTOs)
    repositories/              HealthRepositoryImpl (DTO → entity, exception → Failure)
  presentation/
    cubits/                    HomeCubit, DetailsCubit (call use cases, emit states)
    screens/                   HomeScreen, DoctorDetailsScreen
    widgets/                   reusable UI components
```

Dependencies point inward: **Presentation → Domain ← Data**. The Domain layer
defines the repository interface; the Data layer implements it.

## Data flow

```
Tap / app start
  → HomeCubit.load()                       emits Loading
  → GetHomeFeed()                          use case
  → HealthRepository.getHomeFeed()         interface (Domain)
  → HealthRepositoryImpl                   (Data)
  → HealthRemoteDataSource.getHomeFeed()
  → ApiClient.getJson('/feed')             http.get, status check, jsonDecode
  ← Map<String, dynamic>
  ← HomeFeedModel.fromJson(json)           deserialization (generated)
  ← .toEntity()                            DTO → Domain entity
  ← HomeFeed                               or a Failure (Network / Server / Parsing)
  → HomeCubit emits Success / Empty / Error
  → BlocBuilder rebuilds the screen
```

## Features

- Loading, Success, Empty and Error states on both screens, with "Try again".
- Search, filter by health service or favorites, sort (nearest, name A–Z / Z–A).
- Favorites shared between the list and the details page.
- Pull to refresh calls the API again.
- Clear error messages for no connection, timeout, server errors and bad data.

## Notes

- **The API is read-only.** It has no POST endpoints, so favorites are kept in
  the app and "Book an Appointment" is simulated.
- **`/feed/details` returns the same appointment for every doctor.** From the
  list, the details page shows the tapped doctor with the API's appointment
  data. From the appointment card, it shows the API's own doctor (Dr.Upul).
- **Web browsers:** the API sends no CORS headers, so Chrome blocks the
  requests and the app shows an Error explaining it. Run it on an Android
  emulator / phone, or in Chrome for local testing only:
  `flutter run -d chrome --web-browser-flag "--disable-web-security"`.
- The free Render server can take ~30 s to wake up; the timeout is 45 s.

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # only after changing models
flutter run
flutter test
```

Tests cover JSON serialization (round-trip against real API responses), the
HTTP client's error handling, the repository's failure mapping, the filter use
case, both Cubits, and full app flows against a fake HTTP server.
