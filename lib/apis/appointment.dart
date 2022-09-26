import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../model/appointment.dart';

// Future<List> fetchEmployees() async {
//   Uri url = Uri.parse(" Link ");
//   final response = await http.get(url);
//   return employeesFromJson(response.body);
// }

Future<List<Employees>> fetchResults() async {
  const storage = FlutterSecureStorage();
  var myJwt = await storage.read(key: "jwt");
  var clientid = await storage.read(key: "client_id");
  print(clientid);
  var cliniccode = await storage.read(key: "clinic_code");
  print(cliniccode);
  final uri = Uri.parse('http://localhost:8000/api/v1/searchAppointment')
      .replace(queryParameters: {
    'clinic_code': cliniccode,
    'client_id': clientid,
  });
  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT $myJwt',
      'clinic_code': '$cliniccode'
    },
  );
  var resultsJson = json.decode(response.body).cast<Map<String, dynamic>>();
  List<Employees> emplist = await resultsJson
      .map<Employees>((json) => Employees.fromJson(json))
      .toList();
  return emplist;
}
