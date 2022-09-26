// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_thera/model/profileModel.dart';
import 'package:my_thera/networkHandler.dart';
import 'package:my_thera/screens/client/profile/ProfileScreen.dart';
import 'package:my_thera/screens/client/profile/update_profile.dart';

class MainProfile extends StatefulWidget {
  MainProfile({Key? key}) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();
  ProfileModel profileModel = ProfileModel(
    email: '',
    firstname: '',
    lastname: '',
    middlename: '',
    profileimage: '',
    id: 0,
  );

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    const storage = FlutterSecureStorage();
    var username = await storage.read(key: "userfullname");
    print(username);
    var response =
        await networkHandler.get('http://10.0.2.2:8000/api/v1/user/');
    print(response);
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 196, 222, 235),
      appBar:
          AppBar(centerTitle: true, title: Text('Client Profile'), actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatProfile(
                        firstname: profileModel.firstname,
                        middlename: profileModel.middlename,
                        lastname: profileModel.lastname,
                        profileimage: profileModel.profileimage,
                      )),
            );
          },
          icon: Icon(Icons.edit),
        ),
      ]

              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back),
              //   onPressed: () {},
              //   color: Colors.black,
              // ),

              ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                head(),
                Text(
                  (profileModel.firstname) + " " + (profileModel.lastname),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  profileModel.email,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkHandler().getImage(profileModel.profileimage),
            ),
          ),
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
