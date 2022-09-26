import 'package:json_annotation/json_annotation.dart';

part 'profileModel.g.dart';

@JsonSerializable()
class ProfileModel {
  final int id;
  String firstname;
  String middlename;
  String lastname;
  String email;
  String profileimage;

  ProfileModel(
      {required this.id,
      required this.email,
      required this.firstname,
      required this.middlename,
      required this.lastname,
      required this.profileimage});

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
