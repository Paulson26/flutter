import 'package:json_annotation/json_annotation.dart';

part 'document1.dart';

@JsonSerializable()
class Document extends Object {
  int? id;
  String document;

  List<BatterItem> appts;

  Document({this.id, required this.document, required this.appts});

  factory Document.fromJson(Map<String, dynamic> json) {
    var list = json['appt'] as List;
    List<BatterItem> data = list.map((i) => BatterItem.fromJson(i)).toList();
    return Document(
      id: json["id"],
      document: json["document"],
      appts: data,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

