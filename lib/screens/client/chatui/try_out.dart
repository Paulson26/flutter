// // ignore_for_file: unrelated_type_equality_checks, non_constant_identifier_names

// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:my_thera/model/profileModel.dart';
// import 'package:my_thera/networkHandler.dart';

// class Listm extends StatefulWidget {
//   const Listm({
//     Key? key,
//     required this.receiver,
//     required this.receiver_name,
//   }) : super(key: key);
//   final receiver;
//   final receiver_name;

//   @override
//   State<Listm> createState() => ListmState();
// }

// class ListmState extends State<Listm> {
//   final TextEditingController typedtext = TextEditingController();
//   bool circular = true;
//   NetworkHandler networkHandler = NetworkHandler();
//   List<Message> messages = <Message>[];
//   ProfileModel profileModel = ProfileModel(
//     email: '',
//     firstname: '',
//     lastname: '',
//     middlename: '',
//     profileimage: '',
//     id: 0,
//   );

//   @override
//   void initState() {
//     super.initState();
//     fetchResult();
//     fetchData();
//     typedtext.text = '';
//   }

//   void fetchData() async {
//     const storage = FlutterSecureStorage();
//     var username = await storage.read(key: "userfullname");
//     print(username);
//     var response =
//         await networkHandler.get('http://10.0.2.2:8000/api/v1/user/');
//     setState(() {
//       profileModel = ProfileModel.fromJson(response["data"]);
//       circular = false;
//     });
//   }

//   Future<List<Message>> fetchResult() async {
//     var rid = "${widget.receiver}";
//     const storage = FlutterSecureStorage();
//     var myJwt = await storage.read(key: "jwt");
//     var clientid = await storage.read(key: "client_id");
//     var sid = await storage.read(key: "userid");
//     var cliniccode = await storage.read(key: "clinic_code");
//     print(cliniccode);
//     final uri = Uri.parse('http://10.0.2.2:8000/api/v1/sendmessage/')
//         .replace(queryParameters: {'sender': sid, 'reciver': rid});
//     final response = await http.get(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'JWT $myJwt',
//         'clinic_code': '$cliniccode',
//       },
//     );
//     print(response.body);
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body)['data'];
//       return jsonResponse.map((doc) => Message.fromJson(doc)).toList();
//     } else {
//       throw Exception('Failed to documents  from API');
//     }
//   }

//   Widget buildChatList() {
//     return FutureBuilder<List<Message>>(
//       future: fetchResult(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError ||
//             snapshot.data == null ||
//             snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         }
//         if (snapshot.hasData) {
//           List<Message>? data = snapshot.data!;

//           return SingleChildScrollView(
//             child: ListView.builder(
//               //reverse: true,
//               itemCount: data.length,
//               shrinkWrap: true,
//               padding: const EdgeInsets.only(top: 10, bottom: 10),
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (BuildContext context, int index) {
//                 return Container(
//                   padding: const EdgeInsets.only(
//                       left: 14, right: 14, top: 10, bottom: 10),
//                   child: Align(
//                     alignment: (data[index].sender.id != profileModel.id
//                         ? Alignment.topLeft
//                         : Alignment.topRight),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: (data[index].sender.id != profileModel.id
//                             ? const Color.fromARGB(255, 213, 218, 220)
//                             : const Color.fromARGB(255, 83, 213, 236)),
//                       ),
//                       padding: const EdgeInsets.all(16),
//                       child: Text(
//                         (data[index].message),
//                         style: TextStyle(
//                             fontSize: 15,
//                             color: const Color.fromARGB(241, 17, 16, 16)),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         }
//         return const CircularProgressIndicator();
//       },
//     );
//   }

//   Widget buildChatArea() {
//     return Container(
//       padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
//       height: 60,
//       width: double.infinity,
//       color: Color.fromARGB(255, 217, 179, 179),
//       child: Row(
//         children: <Widget>[
//           GestureDetector(
//             onTap: () {},
//             child: Container(
//               height: 20,
//               width: 20,
//               decoration: BoxDecoration(
//                 color: Colors.lightBlue,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: const Icon(
//                 Icons.add,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 15,
//           ),
//           Expanded(
//             child: TextField(
//               controller: typedtext,
//               decoration: InputDecoration(
//                   hintText: "Write message...",
//                   hintStyle: TextStyle(color: Colors.black54),
//                   border: InputBorder.none),
//             ),
//           ),
//           const SizedBox(
//             width: 5,
//           ),
//           FloatingActionButton(
//             onPressed: () async {
//               if (typedtext.text.isEmpty) {
//                 return null;
//               }
//               const storage = FlutterSecureStorage();
//               var myJwt = await storage.read(key: "jwt");
//               var clientid = await storage.read(key: "client_id");
//               var cliniccode = await storage.read(key: "clinic_code");
//               var senderid = await storage.read(key: "userid");
//               var map = Map<String, String>();

//               map["message"] = typedtext.text;
//               map["reciver"] = "${widget.receiver}";
//               map["sender"] = "$senderid";
//               print(map);

//               final uri = Uri.parse('http://10.0.2.2:8000/api/v1/sendmessage/');
//               // final response = await http.post(
//               //   uri,
//               //   headers: {
//               //     'Authorization': 'JWT $myJwt',
//               //     'clinic_code': '$cliniccode',
//               //   },
//               //   body: map,
//               // );
//               Map<String, String> headers = {
//                 'Authorization': 'JWT $myJwt',
//                 'clinic_code': '$cliniccode',
//               };

//               var request = http.MultipartRequest('POST', uri)
//                 ..fields.addAll(map);
//               request.headers.addAll(headers);
//               var response = await request.send();
//               if (response.statusCode == 200) {
//                 final respStr = await response.stream.bytesToString();
//                 final responseJson = json.decode(respStr);
//                 // socketIO!.sendMessage(
//                 //   'send_message',
//                 //   json.encode({
//                 //     'receiverChatID': receiverChatID,
//                 //     'senderChatID': "$senderid",
//                 //     'message': text,
//                 //   }),
//                 // );
//                 typedtext.text = '';
//                 print(responseJson);
//               } else {
//                 throw Exception('Failed to load api');
//               }
//             },
//             child: Icon(
//               Icons.send,
//               color: Colors.white,
//               size: 18,
//             ),
//             backgroundColor: Colors.blue,
//             elevation: 0,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         backgroundColor: Color.fromARGB(255, 204, 175, 175),
//         flexibleSpace: SafeArea(
//           child: Container(
//             padding: const EdgeInsets.only(right: 16),
//             child: Row(
//               children: <Widget>[
//                 IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 2,
//                 ),
//                 // CircleAvatar(
//                 //   backgroundImage: NetworkImage(
//                 //       "<https://randomuser.me/api/portraits/men/5.jpg>"),
//                 //   maxRadius: 20,
//                 // ),
//                 const SizedBox(
//                   width: 12,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         widget.receiver_name ?? '',
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(
//                         height: 6,
//                       ),
//                       Text(
//                         "Online",
//                         style: TextStyle(
//                             color: Colors.grey.shade600, fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(
//                   Icons.settings,
//                   color: Colors.black54,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: <Widget>[
//           buildChatList(),
//           // Positioned(bottom: 50, child: buildChatArea())
//         ],
//       ),
//       bottomSheet: buildChatArea(),
//     );
//   }
// }

// @JsonSerializable()
// class Message extends Object {
//   String date;
//   String message;
//   bool read;
//   bool related;
//   @JsonKey(name: 'sender')
//   BatterItem sender;
//   @JsonKey(name: 'reciver')
//   BatterItem1 receiver;

//   Message(
//       {required this.date,
//       required this.message,
//       required this.sender,
//       required this.receiver,
//       required this.read,
//       required this.related});

//   factory Message.fromJson(Map<String, dynamic> json) =>
//       _$MessageFromJson(json);
//   Map<String, dynamic> toJson() => _$MessageToJson(this);
// }

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// Message _$MessageFromJson(Map<String, dynamic> json) {
//   return Message(
//       date: json["created_date"],
//       message: json["message"],
//       read: json["read"],
//       related: json["previously_related"],
//       sender: BatterItem.fromJson(json["sender"]),
//       receiver: BatterItem1.fromJson(json["reciver"]));
// }

// Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
//       "created_date": instance.date,
//       "message": instance.message,
//       "read": instance.read,
//       "previously_related": instance.related,
//       "sender": instance.sender,
//       "reciver": instance.receiver
//     };

// @JsonSerializable()
// class BatterItem extends Object {
//   String? avatar;
//   int id;

//   BatterItem({this.avatar, required this.id});

//   factory BatterItem.fromJson(Map<String, dynamic> json) =>
//       _$BatterItemFromJson(json);
//   Map<String, dynamic> toJson() => _$BatterItemToJson(this);
// }

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// BatterItem _$BatterItemFromJson(Map<String, dynamic> json) {
//   return BatterItem(avatar: json["avatar"], id: json["id"]);
// }

// Map<String, dynamic> _$BatterItemToJson(BatterItem instance) =>
//     <String, dynamic>{"id": instance.id, "avatar": instance.avatar};

// @JsonSerializable()
// class BatterItem1 extends Object {
//   int? id;
//   String avatar1;

//   BatterItem1({this.id, required this.avatar1});

//   factory BatterItem1.fromJson(Map<String, dynamic> json) =>
//       _$BatterItem1FromJson(json);
//   Map<String, dynamic> toJson() => _$BatterItem1ToJson(this);
// }

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// BatterItem1 _$BatterItem1FromJson(Map<String, dynamic> json) {
//   return BatterItem1(id: json["id"], avatar1: json["avatar"]);
// }

// Map<String, dynamic> _$BatterItem1ToJson(BatterItem1 instance) =>
//     <String, dynamic>{"id": instance.id, "avatar": instance.avatar1};
