part of 'profileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return ProfileModel(
    id: json['id'],
    email: json['email'],
    firstname: json['first_name'],
    middlename: json['middle_name'],
    lastname: json['last_name'],
    profileimage: json['avatar'] ?? "",
  );
}

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstname,
      'middle_name': instance.middlename,
      'last_name': instance.lastname,
      'email': instance.email,
      'avatar': instance.profileimage,
    };
