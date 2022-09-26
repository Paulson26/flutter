part of 'clincModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClinicModel _$ClinicModelFromJson(Map<String, dynamic> json) {
  return ClinicModel(
    id: json['id'],
    email: json['email'],
    firstname: json['first_name'],
    middlename: json['middle_name'],
    lastname: json['last_name'],
    profileimage: json['avatar'] ?? "",
  );
}

Map<String, dynamic> _$ClinicModelToJson(ClinicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstname,
      'middle_name': instance.middlename,
      'last_name': instance.lastname,
      'email': instance.email,
      'avatar': instance.profileimage,
    };
