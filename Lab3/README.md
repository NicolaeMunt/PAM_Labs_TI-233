# Lab 3 – State Management & async data (Flutter + Cubit)

Health appointment app from Lab 2, rebuilt so that all content comes from a
JSON file loaded asynchronously and all screen state is managed with
**flutter_bloc (Cubit)**.

## Features

- **Async loading** of `assets/data/health_data.json` (`rootBundle.loadString`
  + JSON decoding on a background isolate with `compute`).
- **States:** Loading (spinner), Success (list), Empty (no doctors / no match,
  with "Clear filters"), Error (message + "Try again").
- **Search** by name, specialty or address.
- **Filter** by health service (tap Tooth / Eye / Lungs / Ear) and
  "Favorites only".
- **Sort:** nearest, top rated, price low→high, price high→low, name A–Z.
- **Favorites:** add/remove from the list or the details page; both stay in sync.
- **Details page** with payment, rating/experience/distance, working hours and
  date pickers, and an async "Book an Appointment" action.
- **Pull to refresh** reloads the JSON without losing filters or favorites.

## Structure

```
lib/
  main.dart, app.dart            entry point, providers, MaterialApp
  core/theme/                    colors and theme
  data/
    models/                      Doctor, HealthService, UserProfile,
                                 UpcomingAppointment, AppointmentDetails, HealthData
    repositories/                HealthRepository (interface) + AssetHealthRepository
  logic/
    home/                        HomeCubit + HomeState (load, search, filter, sort, favorites)
    booking/                     BookingCubit (slot selection, booking)
  presentation/
    screens/                     HomeScreen, DoctorDetailsScreen
    widgets/                     reusable UI: DoctorCard, ServiceTile, SearchField,
                                 AppointmentCard, SectionHeader, SlotSelector,
                                 FavoriteButton, PrimaryButton, NetworkAvatar,
                                 SortFilterSheet, Loading/Empty/Error views
test/                            model, cubit (bloc_test) and widget tests
```

## Data

The JSON keeps the structure from the assignment. The doctor list was extended
from 2 to 10 entries, and each doctor got `serviceId`, `rating`, `reviews`,
`experienceYears` and `price`, so search, filtering and sorting have data to
work on. Images load from the URLs in the JSON; the service icons fall back to
the bundled PNGs and photos fall back to initials when offline.

## Run

```bash
flutter pub get
flutter run
flutter test
```
