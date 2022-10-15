import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_thera/apis/appointment.dart';
import 'package:my_thera/screens/client/chatui/message.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:observable/observable.dart';

class chatpage extends StatefulWidget {
  String receiver;
  String receiver_name;

  chatpage({
    required this.receiver,
    required this.receiver_name,
  });
  @override
  _chatpageState createState() =>
      _chatpageState(receiver_name: receiver_name, receiver: receiver);
}

class _chatpageState extends State<chatpage> {
  final TextEditingController typedtext = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController scrollController = ScrollController();
  Socket? socket; //
  //final ScrollController controller = ScrollController();
  String receiver;
  String receiver_name;

  _chatpageState({
    required this.receiver,
    required this.receiver_name,
  });
  late Future<List<Message>> future;
  final TextEditingController message = TextEditingController();
  // Future<List<Message>> fetchResult() async {
  //   var rid = "${widget.receiver}";
  //   const storage = FlutterSecureStorage();
  //   var myJwt = await storage.read(key: "jwt");
  //   var clientid = await storage.read(key: "client_id");
  //   var sid = await storage.read(key: "userid");
  //   var cliniccode = await storage.read(key: "clinic_code");
  //   print(cliniccode);
  //   final uri = Uri.parse('http://10.0.2.2:8000/api/v1/sendmessage/')
  //       .replace(queryParameters: {'sender': sid, 'reciver': rid});
  //   final response = await http.get(
  //     uri,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'JWT $myJwt',
  //       'clinic_code': '$cliniccode',
  //     },
  //   );
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     List jsonResponse = json.decode(response.body)['data'];
  //     return jsonResponse.map((doc) => Message.fromJson(doc)).toList();
  //   } else {
  //     throw Exception('Failed to documents  from API');
  //   }
  // }

  // Future<Null> _refresh() {
  //   return fetchResult().then((_user) {
  //     List<Message> user;
  //     setState(() => user = _user);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    initializeSocket();
    //future = fetchResult();
    // socket!.on('new-msg', (data) {
    //   fetchResult();
    // });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState!.show());
  }

  @override
  void dispose() {
    socket!
        .disconnect(); // --> disconnects the Socket.IO client once the screen is disposed
    super.dispose();
  }

  void initializeSocket() async {
    socket = io("http://127.0.0.1:3000/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    //socket!.init();
    socket!.connect(); //connect the Socket.IO Client to the Server

    //SOCKET EVENTS
    // --> listening for connection
    socket!.on('connect', (data) {
      print(socket!.connected);
    });
    // socket!.subscribe("new_message", _getMessage);
    //listen for incoming messages from the Server.
    // socket!.on('new-message', future);

    //listens when the client is disconnected from the Server
    socket!.on('disconnect', (data) {
      print('disconnect');
    });
  }

  // getMessages() {
  //   return Observable.create((observer) => {
  //         socket!.on('new-msg', (data) {
  //           observer.next(data);
  //         })
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver_name),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.84,
                child: messages(
                  receiver_name: receiver_name,
                  receiver: receiver,
                  // myController: myController,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: typedtext,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.purple[100],
                      hintText: 'Start chatting....',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSaved: (value) {
                      typedtext.text = value!;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (typedtext.text.isNotEmpty) {
                      const storage = FlutterSecureStorage();
                      var myJwt = await storage.read(key: "jwt");
                      var clientid = await storage.read(key: "client_id");
                      var cliniccode = await storage.read(key: "clinic_code");
                      var senderid = await storage.read(key: "userid");
                      var map = Map<String, String>();

                      map["message"] = typedtext.text;
                      map["reciver"] = widget.receiver;
                      map["sender"] = "$senderid";
                      print(map);

                      final uri =
                          Uri.parse('http://10.0.2.2:8000/api/v1/sendmessage/');
                      // final response = await http.post(
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
                        socket!.emit(
                          "new-message",
                          {
                            "message": typedtext.text, //--> message to be sent
                            "reciver": widget.receiver,
                            "sender": "$senderid",
                          },
                        );
                        typedtext.clear();
                        fetchResults();
                        print(responseJson);
                        // scrollController.animateTo(0,
                        //     duration: const Duration(milliseconds: 100),
                        //     curve: Curves.easeOut);
                        //  _refreshIndicatorKey.currentState!.show();

                        // controller.animateTo(
                        //   0.0,
                        //   curve: Curves.easeOut,
                        //   duration: const Duration(milliseconds: 300),
                        // );
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.send_sharp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
