// ignore_for_file: unnecessary_new, depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_thera/model/profileModel.dart';
import 'package:my_thera/networkHandler.dart';
import 'package:socket_io_client/socket_io_client.dart';

class messages extends StatefulWidget {
  String receiver;
  String receiver_name;
  messages({
    required this.receiver,
    required this.receiver_name,
  });
  @override
  _messagesState createState() =>
      _messagesState(receiver_name: receiver_name, receiver: receiver);
}

class _messagesState extends State<messages> {
  String receiver;
  String receiver_name;
  _messagesState({
    required this.receiver,
    required this.receiver_name,
  });
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final TextEditingController typedtext = TextEditingController();

  bool circular = true;
  Socket? socket;
  Timer? timer;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchResults();
    });

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   _myController.animateTo(
    //     _myController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 10),
    //     curve: Curves.easeOut,
    //   );
    // });
    setState(() {
      fetchData();
    });
  }

  // void initializeSocket() {
  //   socket = io("http://127.0.0.1:3000/", <String, dynamic>{
  //     "transports": ["websocket"],
  //     "autoConnect": false,
  //   });
  //   socket!.connect(); //connect the Socket.IO Client to the Server

  //   //SOCKET EVENTS
  //   // --> listening for connection
  //   socket!.on('connect', (data) {
  //     print(socket!.connected);
  //   });

  //   //listen for incoming messages from the Server.
  //   socket!.on('new-message', (data) {
  //     print(data); //
  //   });

  //   //listens when the client is disconnected from the Server
  //   socket!.on('disconnect', (data) {
  //     print('disconnect');
  //   });
  // }

  @override
  void dispose() {
    // socket!
    //     .disconnect(); // --> disconnects the Socket.IO client once the screen is disposed
    super.dispose();
  }

  Future fetchData() async {
    const storage = FlutterSecureStorage();
    var username = await storage.read(key: "userfullname");
    print(username);
    var response =
        await networkHandler.get('http://10.0.2.2:8000/api/v1/user/');
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
  }

  List messaged = [];
  Future fetchResults() async {
    var rid = "${widget.receiver}";
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var sid = await storage.read(key: "userid");
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/sendmessage/')
        .replace(queryParameters: {'sender': sid, 'reciver': rid});

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode',
      },
    );

    print(response.body);
    messaged = json.decode(response.body)['data'];
    List jsonResponse = json.decode(response.body)['data'];
    return jsonResponse;
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < messaged.length; i++) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Center(
            child: Column(
              crossAxisAlignment: messaged[i]['sender']['id'] != profileModel.id
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < messaged.length; i++)
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: (messaged[i]['sender']['id'] != profileModel.id
                              ? const Color.fromARGB(255, 16, 16, 16)
                              : const Color.fromARGB(255, 3, 141, 247)),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        (messaged[i]['message']),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              (messaged[i]['created_date']),
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
