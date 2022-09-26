import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:my_thera/model/clincModel.dart';
import 'package:my_thera/networkHandler.dart';
import 'package:my_thera/screens/client/chatui/list_clinician_clinic.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:my_thera/screens/client/chatui/chat.dart';
import 'dart:convert';

class Chat7 extends StatefulWidget {
  @override
  _Chat7State createState() => _Chat7State();
}

class _Chat7State extends State<Chat7> {
  late Future<List<User>> _future;
  User? _selectedUser;

  String clinician = "";
  bool isClinician = false;
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();
  ClinicModel clinicModel = ClinicModel(
    email: '',
    firstname: '',
    lastname: '',
    middlename: '',
    profileimage: '',
    id: 0,
  );

  void fetchData() async {
    const storage = FlutterSecureStorage();
    var username = await storage.read(key: "userfullname");
    var clinicid = await storage.read(key: "clinic_id");
    print(username);
    var response = await networkHandler
        .get1('http://10.0.2.2:8000/api/v1/getclinicaladmindetails/');
    print(response);
    setState(() {
      clinicModel = ClinicModel.fromJson(response["data"]);
      circular = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    // _future = _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => chatpage(
                  receiver: clinicModel.id.toString(),
                  receiver_name: clinicModel.firstname))),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkHandler().getImage(clinicModel.profileimage),
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
                            clinicModel.firstname,
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
                          clinicModel.email,
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
  }
}

class User {
  String clinicname;
  String avatar;
  String clinicMail;
  int id;
  int lastname;

  User(
      {required this.clinicname,
      required this.clinicMail,
      required this.id,
      required this.lastname,
      required this.avatar});

  User.fromJson(Map<String, dynamic> json)
      : clinicname = json['first_name'],
        id = json['id'],
        lastname = json['last_name'],
        avatar = json['avatar'] ?? "",
        clinicMail = json['staff_email'] ?? "";
}

// class UsersResponse {
//   final List<User> data;

//   const UsersResponse({
//     required this.data,
//   });

//   UsersResponse.fromJson(Map<String, dynamic> json)
//       : data = (json['clinician_visited'] as List<dynamic>)
//             .map((json) => User.fromJson(json))
//             .toList();
// }
