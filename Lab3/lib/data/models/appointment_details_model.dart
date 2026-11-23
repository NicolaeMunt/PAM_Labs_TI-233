import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/appointment_details.dart';

part 'appointment_details_model.g.dart';

// DTOs that mirror the JSON from GET /feed/details exactly.
// `fromJson` / `toJson` are generated into appointment_details_model.g.dart.

@JsonSerializable(explicitToJson: true)
class AppointmentDetailsModel {
  final String title;
  final DetailsDoctorModel doctor;
  final PaymentModel payment;
  final DetailsSectionModel details;
  final SlotGroupModel workingHours;

  /// The JSON key is "date"; the Dart name says what it holds.
  @JsonKey(name: 'date')
  final SlotGroupModel dates;
  final DetailsActionsModel actions;

  const AppointmentDetailsModel({
    required this.title,
    required this.doctor,
    required this.payment,
    required this.details,
    required this.workingHours,
    required this.dates,
    required this.actions,
  });

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentDetailsModelToJson(this);

  AppointmentDetails toEntity() => AppointmentDetails(
    title: title,
    doctor: doctor.toEntity(),
    paymentLabel: payment.label,
    paymentAmount: payment.amount,
    currency: payment.currency,
    formattedPrice: payment.formatted,
    detailsTitle: details.title,
    description: details.description,
    workingHours: workingHours.toEntity(),
    dates: dates.toEntity(),
    bookLabel: actions.bookAppointment.label,
    bookEnabled: actions.bookAppointment.enabled,
  );
}

@JsonSerializable(explicitToJson: true)
class DetailsDoctorModel {
  final String name;
  @JsonKey(defaultValue: '')
  final String clinic;
  @JsonKey(defaultValue: '')
  final String avatarUrl;
  final ContactActionsModel actions;

  const DetailsDoctorModel({
    required this.name,
    required this.clinic,
    required this.avatarUrl,
    required this.actions,
  });

  factory DetailsDoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DetailsDoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsDoctorModelToJson(this);

  DetailsDoctor toEntity() => DetailsDoctor(
    name: name,
    clinic: clinic,
    avatarUrl: avatarUrl,
    canMessage: actions.message,
    canCall: actions.call,
    canVideoCall: actions.videoCall,
  );
}

@JsonSerializable()
class ContactActionsModel {
  @JsonKey(defaultValue: false)
  final bool message;
  @JsonKey(defaultValue: false)
  final bool call;
  @JsonKey(defaultValue: false)
  final bool videoCall;

  const ContactActionsModel({
    required this.message,
    required this.call,
    required this.videoCall,
  });

  factory ContactActionsModel.fromJson(Map<String, dynamic> json) =>
      _$ContactActionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactActionsModelToJson(this);
}

@JsonSerializable()
class PaymentModel {
  final String label;

  /// JSON number (120.0); json_serializable converts it to double.
  final double amount;
  final String currency;
  final String formatted;

  const PaymentModel({
    required this.label,
    required this.amount,
    required this.currency,
    required this.formatted,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}

@JsonSerializable()
class DetailsSectionModel {
  final String title;
  @JsonKey(defaultValue: '')
  final String description;

  const DetailsSectionModel({required this.title, required this.description});

  factory DetailsSectionModel.fromJson(Map<String, dynamic> json) =>
      _$DetailsSectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsSectionModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SlotGroupModel {
  final String title;
  @JsonKey(defaultValue: false)
  final bool showAll;
  @JsonKey(defaultValue: <TimeSlotModel>[])
  final List<TimeSlotModel> slots;

  const SlotGroupModel({
    required this.title,
    required this.showAll,
    required this.slots,
  });

  factory SlotGroupModel.fromJson(Map<String, dynamic> json) =>
      _$SlotGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$SlotGroupModelToJson(this);

  SlotGroup toEntity() =>
      SlotGroup(title: title, slots: slots.map((s) => s.toEntity()).toList());
}

@JsonSerializable()
class TimeSlotModel {
  final String id;
  final String label;
  @JsonKey(defaultValue: false)
  final bool selected;

  const TimeSlotModel({
    required this.id,
    required this.label,
    required this.selected,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotModelToJson(this);

  TimeSlot toEntity() => TimeSlot(id: id, label: label, selected: selected);
}

@JsonSerializable(explicitToJson: true)
class DetailsActionsModel {
  final ActionModel bookAppointment;

  const DetailsActionsModel({required this.bookAppointment});

  factory DetailsActionsModel.fromJson(Map<String, dynamic> json) =>
      _$DetailsActionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsActionsModelToJson(this);
}

@JsonSerializable()
class ActionModel {
  final String label;
  @JsonKey(defaultValue: true)
  final bool enabled;

  const ActionModel({required this.label, required this.enabled});

  factory ActionModel.fromJson(Map<String, dynamic> json) =>
      _$ActionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActionModelToJson(this);
}
