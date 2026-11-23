import 'package:equatable/equatable.dart';

/// Content of the details screen, from GET /feed/details.
class AppointmentDetails extends Equatable {
  final String title;
  final DetailsDoctor doctor;
  final String paymentLabel;
  final double paymentAmount;
  final String currency;

  /// Price text as sent by the API, e.g. "$120.00".
  final String formattedPrice;
  final String detailsTitle;
  final String description;
  final SlotGroup workingHours;
  final SlotGroup dates;
  final String bookLabel;
  final bool bookEnabled;

  const AppointmentDetails({
    required this.title,
    required this.doctor,
    required this.paymentLabel,
    required this.paymentAmount,
    required this.currency,
    required this.formattedPrice,
    required this.detailsTitle,
    required this.description,
    required this.workingHours,
    required this.dates,
    required this.bookLabel,
    required this.bookEnabled,
  });

  @override
  List<Object?> get props => [
    title,
    doctor,
    paymentLabel,
    paymentAmount,
    currency,
    formattedPrice,
    detailsTitle,
    description,
    workingHours,
    dates,
    bookLabel,
    bookEnabled,
  ];
}

/// The doctor described by the details endpoint, and how you can contact them.
class DetailsDoctor extends Equatable {
  final String name;
  final String clinic;
  final String avatarUrl;
  final bool canMessage;
  final bool canCall;
  final bool canVideoCall;

  const DetailsDoctor({
    required this.name,
    required this.clinic,
    required this.avatarUrl,
    this.canMessage = true,
    this.canCall = true,
    this.canVideoCall = true,
  });

  @override
  List<Object?> get props => [
    name,
    clinic,
    avatarUrl,
    canMessage,
    canCall,
    canVideoCall,
  ];
}

/// A selectable pill (an hour or a day).
class TimeSlot extends Equatable {
  final String id;
  final String label;
  final bool selected;

  const TimeSlot({
    required this.id,
    required this.label,
    this.selected = false,
  });

  @override
  List<Object?> get props => [id, label, selected];
}

/// A titled list of slots, e.g. "Working Hours" or "Date".
class SlotGroup extends Equatable {
  final String title;
  final List<TimeSlot> slots;

  const SlotGroup({required this.title, required this.slots});

  /// Id of the slot the API marks as selected, or the first one.
  String? get initialSelectionId {
    for (final slot in slots) {
      if (slot.selected) return slot.id;
    }
    return slots.isEmpty ? null : slots.first.id;
  }

  String labelFor(String? id) =>
      slots.where((s) => s.id == id).map((s) => s.label).firstOrNull ?? '';

  @override
  List<Object?> get props => [title, slots];
}
