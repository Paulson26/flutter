import 'package:json_annotation/json_annotation.dart';

part 'clinicModel.g.dart';

@JsonSerializable()
class ClinicModel {
  final int id;
  String firstname;
  String middlename;
  String lastname;
  String email;
  String profileimage;

  ClinicModel(
      {required this.id,
      required this.email,
      required this.firstname,
      required this.middlename,
      required this.lastname,
      required this.profileimage});

  factory ClinicModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicModelFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicModelToJson(this);
}
