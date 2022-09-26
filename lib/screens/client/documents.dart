// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentPage> {
  Future<List<Document>> fetchResults() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/document/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((doc) => Document.fromJson(doc)).toList();
    } else {
      throw Exception('Failed to documents  from API');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            FutureBuilder<List<Document>>(
              future: fetchResults(),
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return DataTable(
                  dividerThickness: 5,
                  dataRowHeight: 80,
                  showBottomBorder: true,
                  headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.black),
                  columns: const [
                    DataColumn(
                        label: Text('ID',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Clinician',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Document',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  columnSpacing: 18,
                  horizontalMargin: 10,
                  showCheckboxColumn: true,
                  rows: List.generate(
                    snapshot.data!.length,
                    (index) {
                      var appt = snapshot.data![index];
                      return DataRow(cells: [
                        DataCell(
                          Text(
                            appt.id.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            appt.appts.assignedstaff,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            appt.document,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]);
                    },
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

@JsonSerializable()
class Document extends Object {
  int id;
  String document;
  @JsonKey(name: 'appt')
  BatterItem appts;

  Document({required this.id, required this.document, required this.appts});

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return Document(
      id: json["id"],
      document: json["document"],
      appts: BatterItem.fromJson(json["appt"]));
}

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      "id": instance.id,
      "document": instance.document,
      "appt": instance.appts
    };

@JsonSerializable()
class BatterItem extends Object {
  int? id;
  String assignedstaff;

  BatterItem({this.id, required this.assignedstaff});

  factory BatterItem.fromJson(Map<String, dynamic> json) =>
      _$BatterItemFromJson(json);
  Map<String, dynamic> toJson() => _$BatterItemToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatterItem _$BatterItemFromJson(Map<String, dynamic> json) {
  return BatterItem(id: json["id"], assignedstaff: json["assigned_staff"]);
}

Map<String, dynamic> _$BatterItemToJson(BatterItem instance) =>
    <String, dynamic>{
      "id": instance.id,
      "assigned_staff": instance.assignedstaff
    };
