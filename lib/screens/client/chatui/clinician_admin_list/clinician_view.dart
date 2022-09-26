import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_thera/screens/client/chatui/list_clinician_clinic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:my_thera/screens/client/chatui/chat.dart';
import 'dart:convert';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Future<List<User>> _future;
  User? _selectedUser;

  String clinician = "";
  bool isClinician = false;

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
    // print(response.body);
    Map<String, dynamic> json = jsonDecode(response.body)['data'];
    print(json);
    final usersResponse = UsersResponse.fromJson(json);
    return usersResponse.data;
  }

  @override
  void initState() {
    super.initState();
    _future = _getUsers();
    _getValue();
  }

  _getValue() {
    setState(() {
      clinician = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.data == null) {
          return const CircularProgressIndicator();
        }
        return Scaffold(
            body: ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            List<User>? data = snapshot.data!;
            return GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => chatpage(
                      receiver: data[index].userid.toString(),
                      receiver_name: data[index].staffName))),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNL_ZnOTpXSvhf1UaK7beHey2BX42U6solRA&usqp=CAU'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data[index].staffName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              data[index].staffMail,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
      },
    );
  }
}

class User {
  String staffName;
  String staffMail;
  int id;
  int userid;

  User(
      {required this.staffName,
      required this.staffMail,
      required this.id,
      required this.userid});

  User.fromJson(Map<String, dynamic> json)
      : staffName = json['staff_name'],
        id = json['id'],
        userid = json['user_id'],
        staffMail = json['staff_email'] ?? "";
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
