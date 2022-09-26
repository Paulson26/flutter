import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:my_thera/screens/client/chatui/chat.dart';
import 'dart:convert';

import 'package:my_thera/screens/client/chatui/try_out.dart';
import 'package:my_thera/screens/client/chatui/wats.dart';

class list extends StatefulWidget {
  @override
  State<list> createState() => listState();
}

Future<List<Message>> fetchResults() async {
  const storage = FlutterSecureStorage();
  var myJwt = await storage.read(key: "jwt");
  var clientid = await storage.read(key: "client_id");
  print(clientid);
  var cliniccode = await storage.read(key: "clinic_code");
  print(cliniccode);
  final uri = Uri.parse('http://10.0.2.2:8000/api/v1/sendmessage')
      .replace(queryParameters: {
    'sender': cliniccode,
    'reciver': clientid,
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
  print(response.body);
  var resultsJson = json.decode(response.body).cast<Map<String, dynamic>>();
  List<Message> applist =
      await resultsJson.map<Message>((json) => Message.fromJson(json)).toList();
  return applist;
}

class User {
  String staffName;
  int id;
  int userid;

  User({required this.staffName, required this.id, required this.userid});

  User.fromJson(Map<String, dynamic> json)
      : staffName = json['staff_name'],
        id = json['id'],
        userid = json['user_id'];
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

class Message {
  final String text;
  final String sender;
  final String receiver;
  final bool previouslyrelated;
  final bool read;

  Message(
      this.text, this.sender, this.receiver, this.previouslyrelated, this.read);
  Message.fromJson(Map<String, dynamic> json)
      : text = json['message'] ?? '',
        sender = json['sender'],
        receiver = json['reciver'],
        previouslyrelated = json['previously_related'],
        read = json['read'];
  Map<String, dynamic> toJson() => {
        "message": text,
        "sender": sender,
        "reciver": receiver,
        "previously_related": previouslyrelated,
        "read": read
      };
}

class listState extends State<list> {
  late Future<List<User>> _future;
  User? _selectedUser;

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
      clinician = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Clinician to chat "),
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
                                    "Select  Clinican to chat",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 4, 2, 2)),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                onChanged: (user) {
                                  setState(() {
                                    _selectedUser = user;
                                    clinician =
                                        _selectedUser!.userid.toString();
                                    print(clinician);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => chatpage(
                                                  receiver: clinician,
                                                  receiver_name: _selectedUser!
                                                      .staffName
                                                      .toString(),
                                                )));
                                  });
                                },
                                value: _selectedUser,
                                items: [
                                  ...snapshot.data!.map(
                                    (user) => DropdownMenuItem(
                                      value: user,
                                      onTap: () {},
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
          ],
        )),
      ),
    );
  }
}
