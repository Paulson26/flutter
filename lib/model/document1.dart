part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

@JsonSerializable()
class BatterItem extends Object {
  int? id;
  String assignedstaff;

  BatterItem({this.id, required this.assignedstaff});

  factory BatterItem.fromJson(Map<String, dynamic> json) =>
      _$BatterItemFromJson(json);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatterItem _$BatterItemFromJson(Map<String, dynamic> json) {
  return BatterItem(id: json["id"], assignedstaff: json["assigned_staff"]);
}
