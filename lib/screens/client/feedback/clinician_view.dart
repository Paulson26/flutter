import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_thera/screens/main_screen_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewsClinician extends StatefulWidget {
  @override
  State<ReviewsClinician> createState() => ReviewsClinicianState();
}

class User {
  String staffName;

  User({
    required this.staffName,
  });

  User.fromJson(Map<String, dynamic> json) : staffName = json['staff_name'];
}

class UsersResponse {
  final List<User> data;

  const UsersResponse({
    required this.data,
  });

  UsersResponse.fromJson(Map<String, dynamic> json)
      : data = (json['clinician_visited'] as List<dynamic>)
            .map((json) => User.fromJson(json))
            .toList();
}

class ReviewsClinicianState extends State<ReviewsClinician> {
  late Future<List<User>> _future;
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    _future = _getUsers();
    _getValue();
  }

  Future<List<User>> _getUsers() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/populate-data/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );
    print(response.body);
    Map<String, dynamic> json = jsonDecode(response.body)['data'];
    final usersResponse = UsersResponse.fromJson(json);
    return usersResponse.data;
  }

  _getValue() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clinician Feedback "),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // index: _stackIndex,
        child: (Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            FutureBuilder<List<User>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.data == null) {
                    return const CircularProgressIndicator();
                  }

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 64,
                          child: DropdownButton<User>(
                            hint: Container(
                              width: 150, //and here
                              child: const Text(
                                "Select your Clinican to rate",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 4, 2, 2)),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            onChanged: (user) {
                              setState(() {
                                _selectedUser = user;
                                print(_selectedUser!.staffName);
                              });
                            },
                            value: _selectedUser,
                            items: [
                              ...snapshot.data!.map(
                                (user) => DropdownMenuItem(
                                  value: user,
                                  child: Row(
                                    children: [
                                      Text(user.staffName),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            Container(
              height: 50.0,
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () async {
                  const storage = FlutterSecureStorage();
                  var myJwt = await storage.read(key: "jwt");
                  var cliniccode = await storage.read(key: "clinic_code");
                  var clientId = await storage.read(key: "client_id");
                  var map = Map<String, String>();

                  map["rated_by"] = "$clientId";
                  map["clinician_id"] = this._selectedUser!.staffName;

                  final uri = Uri.parse(
                      'http://10.0.2.2:8000/api/v1/clinicianfeedback/');
                  //final response = await http.post(
                  //   uri,
                  //   headers: {
                  //     'Authorization': 'JWT $myJwt',
                  //     'clinic_code': '$cliniccode',
                  //   },
                  //   body: map,
                  // );
                  Map<String, String> headers = {
                    'Authorization': 'JWT $myJwt',
                    'clinic_code': '$cliniccode',
                  };
                  var request = http.MultipartRequest('POST', uri)
                    ..fields.addAll(map);
                  request.headers.addAll(headers);
                  var response = await request.send();
                  if (response.statusCode == 200) {
                    final respStr = await response.stream.bytesToString();
                    final responseJson = json.decode(respStr);
                    print(responseJson);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MainScreen()),
                        (route) => false);
                    Fluttertoast.showToast(
                        msg:
                            "Thank you for reaching out and providing us with valuable feedback.",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    throw Exception('Failed to load api');
                  }
                },
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(0, 255, 255, 255),
                          Color.fromARGB(0, 111, 121, 142)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Submit Feedback",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 150,
            ),
          ],
        )),
      ),
    );
  }
}
