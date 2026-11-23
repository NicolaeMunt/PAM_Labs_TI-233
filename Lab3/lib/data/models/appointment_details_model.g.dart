// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentDetailsModel _$AppointmentDetailsModelFromJson(
  Map<String, dynamic> json,
) => AppointmentDetailsModel(
  title: json['title'] as String,
  doctor: DetailsDoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
  payment: PaymentModel.fromJson(json['payment'] as Map<String, dynamic>),
  details: DetailsSectionModel.fromJson(
    json['details'] as Map<String, dynamic>,
  ),
  workingHours: SlotGroupModel.fromJson(
    json['workingHours'] as Map<String, dynamic>,
  ),
  dates: SlotGroupModel.fromJson(json['date'] as Map<String, dynamic>),
  actions: DetailsActionsModel.fromJson(
    json['actions'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AppointmentDetailsModelToJson(
  AppointmentDetailsModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'doctor': instance.doctor.toJson(),
  'payment': instance.payment.toJson(),
  'details': instance.details.toJson(),
  'workingHours': instance.workingHours.toJson(),
  'date': instance.dates.toJson(),
  'actions': instance.actions.toJson(),
};

DetailsDoctorModel _$DetailsDoctorModelFromJson(Map<String, dynamic> json) =>
    DetailsDoctorModel(
      name: json['name'] as String,
      clinic: json['clinic'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      actions: ContactActionsModel.fromJson(
        json['actions'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$DetailsDoctorModelToJson(DetailsDoctorModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'clinic': instance.clinic,
      'avatarUrl': instance.avatarUrl,
      'actions': instance.actions.toJson(),
    };

ContactActionsModel _$ContactActionsModelFromJson(Map<String, dynamic> json) =>
    ContactActionsModel(
      message: json['message'] as bool? ?? false,
      call: json['call'] as bool? ?? false,
      videoCall: json['videoCall'] as bool? ?? false,
    );

Map<String, dynamic> _$ContactActionsModelToJson(
  ContactActionsModel instance,
) => <String, dynamic>{
  'message': instance.message,
  'call': instance.call,
  'videoCall': instance.videoCall,
};

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
  label: json['label'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  formatted: json['formatted'] as String,
);

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'amount': instance.amount,
      'currency': instance.currency,
      'formatted': instance.formatted,
    };

DetailsSectionModel _$DetailsSectionModelFromJson(Map<String, dynamic> json) =>
    DetailsSectionModel(
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$DetailsSectionModelToJson(
  DetailsSectionModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
};

SlotGroupModel _$SlotGroupModelFromJson(Map<String, dynamic> json) =>
    SlotGroupModel(
      title: json['title'] as String,
      showAll: json['showAll'] as bool? ?? false,
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$SlotGroupModelToJson(SlotGroupModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'showAll': instance.showAll,
      'slots': instance.slots.map((e) => e.toJson()).toList(),
    };

TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) =>
    TimeSlotModel(
      id: json['id'] as String,
      label: json['label'] as String,
      selected: json['selected'] as bool? ?? false,
    );

Map<String, dynamic> _$TimeSlotModelToJson(TimeSlotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'selected': instance.selected,
    };

DetailsActionsModel _$DetailsActionsModelFromJson(Map<String, dynamic> json) =>
    DetailsActionsModel(
      bookAppointment: ActionModel.fromJson(
        json['bookAppointment'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$DetailsActionsModelToJson(
  DetailsActionsModel instance,
) => <String, dynamic>{'bookAppointment': instance.bookAppointment.toJson()};

ActionModel _$ActionModelFromJson(Map<String, dynamic> json) => ActionModel(
  label: json['label'] as String,
  enabled: json['enabled'] as bool? ?? true,
);

Map<String, dynamic> _$ActionModelToJson(ActionModel instance) =>
    <String, dynamic>{'label': instance.label, 'enabled': instance.enabled};
