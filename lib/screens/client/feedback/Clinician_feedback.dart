import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_thera/screens/main_screen_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewsClinician extends StatefulWidget {
  @override
  State<ReviewsClinician> createState() => ReviewsClinicianState();
}

class User {
  String staffName;
  int id;

  User({required this.staffName, required this.id});

  User.fromJson(Map<String, dynamic> json)
      : staffName = json['staff_name'],
        id = json['id'];
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
  final _feedback = TextEditingController();
  String _clinician_communication = "";
  String _clinician_sattisfaction = "";
  String _solution_to_the_problem = "";
  double _rating = 0.0;

  String clinician = "";
  bool isClinician = false;

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
    setState(() {
      _feedback.text = '';
      clinician = "";
    });
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
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
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
                                    clinician = _selectedUser!.id.toString();
                                    print(clinician);
                                    isClinician = true;
                                  });
                                },
                                value: _selectedUser,
                                items: [
                                  ...snapshot.data!.map(
                                    (user) => DropdownMenuItem(
                                      value: user,
                                      onTap: () {
                                        _handleSelectedUser();
                                      },
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
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            if (isClinician == true)
              Text(
                'How satisfied are you with our clinician services?',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Excellent",
                value: "Excellent",
                groupValue: _clinician_sattisfaction,
                onChanged: (value) => setState(() {
                  _clinician_sattisfaction = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Good",
                value: "Good",
                groupValue: _clinician_sattisfaction,
                onChanged: (value) => setState(() {
                  _clinician_sattisfaction = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Average",
                value: "Average",
                groupValue: _clinician_sattisfaction,
                onChanged: (value) => setState(() {
                  _clinician_sattisfaction = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Poor",
                value: "Poor",
                groupValue: _clinician_sattisfaction,
                onChanged: (value) => setState(() {
                  _clinician_sattisfaction = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Very Poor",
                value: "Very Poor",
                groupValue: _clinician_sattisfaction,
                onChanged: (value) => setState(() {
                  _clinician_sattisfaction = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            const SizedBox(
              height: 10,
            ),
            if (isClinician == true)
              Text(
                'How do you feel our clinician communicated to you?',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Excellent",
                value: "Excellent",
                groupValue: _clinician_communication,
                onChanged: (value) => setState(() {
                  _clinician_communication = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Good",
                value: "Good",
                groupValue: _clinician_communication,
                onChanged: (value) => setState(() {
                  _clinician_communication = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Average",
                value: "Average",
                groupValue: _clinician_communication,
                onChanged: (value) => setState(() {
                  _clinician_communication = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Poor",
                value: "Poor",
                groupValue: _clinician_communication,
                onChanged: (value) => setState(() {
                  _clinician_communication = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Very Poor",
                value: "Very Poor",
                groupValue: _clinician_communication,
                onChanged: (value) => setState(() {
                  _clinician_communication = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              const SizedBox(
                height: 10,
              ),
            if (isClinician == true)
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    Text(
                      'How do you rate our clinician on the basis of solution to your problem?',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Excellent",
                value: "Excellent",
                groupValue: _solution_to_the_problem,
                onChanged: (value) => setState(() {
                  _solution_to_the_problem = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Good",
                value: "Good",
                groupValue: _solution_to_the_problem,
                onChanged: (value) => setState(() {
                  _solution_to_the_problem = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Average",
                value: "Average",
                groupValue: _solution_to_the_problem,
                onChanged: (value) => setState(() {
                  _solution_to_the_problem = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Poor",
                value: "Poor",
                groupValue: _solution_to_the_problem,
                onChanged: (value) => setState(() {
                  _solution_to_the_problem = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              RadioButton(
                description: "Very Poor",
                value: "Very Poor",
                groupValue: _solution_to_the_problem,
                onChanged: (value) => setState(() {
                  _solution_to_the_problem = value.toString();
                }),
                activeColor: Colors.pink,
                textStyle: const TextStyle(
                    // fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            if (isClinician == true)
              const SizedBox(
                height: 10,
              ),
            if (isClinician == true)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: TextFormField(
                    controller: _feedback,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'What can we do to improve our service?',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF0B0303),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF0B0303),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
              ),
            if (isClinician == true)
              const SizedBox(
                height: 10,
              ),
            if (isClinician == true)
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _rating = rating.toDouble();
                  print(_rating);
                },
              ),
            if (isClinician == true)
              Container(
                height: 50.0,
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    const storage = FlutterSecureStorage();
                    var myJwt = await storage.read(key: "jwt");
                    var cliniccode = await storage.read(key: "clinic_code");
                    var clientId = await storage.read(key: "client_id");
                    var map = <String, String>{};
                    map['feedback'] = _feedback.text;

                    map["clinician_communication"] = _clinician_communication;
                    map["clinician_sattisfaction"] = _clinician_sattisfaction;
                    map["rating"] = "$_rating";
                    map["solution_to_the_problem"] = _solution_to_the_problem;
                    map["rated_by"] = "$clientId";
                    map["clinician_id"] = "${_selectedUser!.id}";

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
                      constraints: const BoxConstraints(
                          maxWidth: 250.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: const Text(
                        "Submit Feedback",
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        )),
      ),
    );
  }
}

void _handleSelectedUser() {}
