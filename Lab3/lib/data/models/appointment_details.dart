import 'package:equatable/equatable.dart';

/// A selectable pill on the details screen (an hour or a day).
class TimeSlot extends Equatable {
  final String id;
  final String label;
  final bool selected;

  const TimeSlot({
    required this.id,
    required this.label,
    this.selected = false,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
    id: json['id'] as String,
    label: json['label'] as String? ?? '',
    selected: json['selected'] as bool? ?? false,
  );

  @override
  List<Object?> get props => [id, label, selected];
}

/// A titled list of slots, e.g. "Working Hours" or "Date".
class SlotGroup extends Equatable {
  final String title;
  final List<TimeSlot> slots;

  const SlotGroup({required this.title, required this.slots});

  factory SlotGroup.fromJson(Map<String, dynamic> json) => SlotGroup(
    title: json['title'] as String? ?? '',
    slots: (json['slots'] as List<dynamic>? ?? const [])
        .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  /// Id of the slot marked `"selected": true`, or the first one.
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

/// Shared content of the details screen ("appointmentDetails" in the JSON).
class AppointmentDetails extends Equatable {
  final String title;
  final String paymentLabel;

  /// Price used when a doctor has no own price in the JSON.
  final double paymentAmount;
  final String currency;
  final String detailsTitle;
  final String description;
  final SlotGroup workingHours;
  final SlotGroup dates;
  final bool canMessage;
  final bool canCall;
  final bool canVideoCall;
  final String bookLabel;
  final bool bookEnabled;

  const AppointmentDetails({
    required this.title,
    required this.paymentLabel,
    this.paymentAmount = 0,
    required this.currency,
    required this.detailsTitle,
    required this.description,
    required this.workingHours,
    required this.dates,
    this.canMessage = true,
    this.canCall = true,
    this.canVideoCall = true,
    required this.bookLabel,
    this.bookEnabled = true,
  });

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> obj(Map<String, dynamic>? m, String key) =>
        m?[key] as Map<String, dynamic>? ?? const {};

    final doctorActions = obj(obj(json, 'doctor'), 'actions');
    final payment = obj(json, 'payment');
    final details = obj(json, 'details');
    final book = obj(obj(json, 'actions'), 'bookAppointment');

    return AppointmentDetails(
      title: json['title'] as String? ?? 'Appointment',
      paymentLabel: payment['label'] as String? ?? 'Payment',
      paymentAmount: (payment['amount'] as num?)?.toDouble() ?? 0,
      currency: payment['currency'] as String? ?? 'USD',
      detailsTitle: details['title'] as String? ?? 'Details',
      description: details['description'] as String? ?? '',
      workingHours: SlotGroup.fromJson(obj(json, 'workingHours')),
      dates: SlotGroup.fromJson(obj(json, 'date')),
      canMessage: doctorActions['message'] as bool? ?? true,
      canCall: doctorActions['call'] as bool? ?? true,
      canVideoCall: doctorActions['videoCall'] as bool? ?? true,
      bookLabel: book['label'] as String? ?? 'Book an Appointment',
      bookEnabled: book['enabled'] as bool? ?? true,
    );
  }

  /// "$120.00" for USD, "120.00 EUR" otherwise.
  String formatPrice(double amount) => currency == 'USD'
      ? '\$${amount.toStringAsFixed(2)}'
      : '${amount.toStringAsFixed(2)} $currency';

  @override
  List<Object?> get props => [
    title,
    paymentLabel,
    paymentAmount,
    currency,
    detailsTitle,
    description,
    workingHours,
    dates,
    canMessage,
    canCall,
    canVideoCall,
    bookLabel,
    bookEnabled,
  ];
}
