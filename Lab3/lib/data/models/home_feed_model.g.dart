// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeFeedModel _$HomeFeedModelFromJson(Map<String, dynamic> json) =>
    HomeFeedModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      notifications: NotificationsModel.fromJson(
        json['notifications'] as Map<String, dynamic>,
      ),
      search: SearchModel.fromJson(json['search'] as Map<String, dynamic>),
      appointment: AppointmentModel.fromJson(
        json['appointment'] as Map<String, dynamic>,
      ),
      healthServices:
          (json['healthServices'] as List<dynamic>?)
              ?.map(
                (e) => HealthServiceModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      nearbyDoctors:
          (json['nearbyDoctors'] as List<dynamic>?)
              ?.map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HomeFeedModelToJson(HomeFeedModel instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'notifications': instance.notifications.toJson(),
      'search': instance.search.toJson(),
      'appointment': instance.appointment.toJson(),
      'healthServices': instance.healthServices.map((e) => e.toJson()).toList(),
      'nearbyDoctors': instance.nearbyDoctors.map((e) => e.toJson()).toList(),
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  name: json['name'] as String,
  greeting: json['greeting'] as String,
  subtitle: json['subtitle'] as String? ?? '',
  avatarUrl: json['avatarUrl'] as String? ?? '',
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'name': instance.name,
  'greeting': instance.greeting,
  'subtitle': instance.subtitle,
  'avatarUrl': instance.avatarUrl,
};

NotificationsModel _$NotificationsModelFromJson(Map<String, dynamic> json) =>
    NotificationsModel(hasUnread: json['hasUnread'] as bool? ?? false);

Map<String, dynamic> _$NotificationsModelToJson(NotificationsModel instance) =>
    <String, dynamic>{'hasUnread': instance.hasUnread};

SearchModel _$SearchModelFromJson(Map<String, dynamic> json) =>
    SearchModel(hint: json['hint'] as String? ?? 'Search');

Map<String, dynamic> _$SearchModelToJson(SearchModel instance) =>
    <String, dynamic>{'hint': instance.hint};

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      title: json['title'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      doctor: AppointmentDoctorModel.fromJson(
        json['doctor'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'date': instance.date,
      'time': instance.time,
      'doctor': instance.doctor.toJson(),
    };

AppointmentDoctorModel _$AppointmentDoctorModelFromJson(
  Map<String, dynamic> json,
) => AppointmentDoctorModel(
  name: json['name'] as String,
  specialty: json['specialty'] as String? ?? '',
  avatarUrl: json['avatarUrl'] as String? ?? '',
);

Map<String, dynamic> _$AppointmentDoctorModelToJson(
  AppointmentDoctorModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'specialty': instance.specialty,
  'avatarUrl': instance.avatarUrl,
};

HealthServiceModel _$HealthServiceModelFromJson(Map<String, dynamic> json) =>
    HealthServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String? ?? '',
    );

Map<String, dynamic> _$HealthServiceModelToJson(HealthServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconUrl': instance.iconUrl,
    };

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  id: json['id'] as String,
  name: json['name'] as String,
  specialty: json['specialty'] as String? ?? '',
  distance: json['distance'] as String? ?? '',
  avatarUrl: json['avatarUrl'] as String? ?? '',
  isFavorite: json['isFavorite'] as bool? ?? false,
);

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'specialty': instance.specialty,
      'distance': instance.distance,
      'avatarUrl': instance.avatarUrl,
      'isFavorite': instance.isFavorite,
    };
