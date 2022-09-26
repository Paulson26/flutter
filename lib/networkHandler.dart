import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  var log = Logger();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Future get(String url) async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    // /user/register
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/user/')
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
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future get1(String url) async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    var clinicid = await storage.read(key: "clinic_id");
    print(cliniccode);

    final uri =
        Uri.parse('http://10.0.2.2:8000/api/v1/getclinicaladmindetails/')
            .replace(queryParameters: {'clinic_id': clinicid});
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.Response> put(String uri, Map<String, String> body,
      {required Map<String, String> data}) async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var id = await storage.read(key: "userid");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    log.d(body);
    // /user/register
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/user/$id');

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'id': '$id',
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filepath,
      {required Map<String, String> data}) async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var id = await storage.read(key: "userid");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    var request = http.MultipartRequest(
        'PUT', Uri.parse('http://10.0.2.2:8000/api/v1/user/$id'));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      'Authorization': 'JWT $myJwt',
      'clinic_code': '$cliniccode'
    });
    var response = request.send();
    return response;
  }

  String formater(String uri) {
    return uri;
  }

  NetworkImage getImage(String imageFile) {
    String uri = formater("http://10.0.2.2:8000$imageFile");
    return NetworkImage(uri);
  }

  Future<http.Response> post(String uri, Map<String, String> body,
      {required Map<String, String> data}) async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var id = await storage.read(key: "userid");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    log.d(body);
    // /user/register
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/support/');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
      body: json.encode(body),
    );
    return response;
  }
}
