// // ignore_for_file: unrelated_type_equality_checks

// import 'dart:async';

// import 'package:emoji_picker/emoji_picker.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:my_thera/model/profileModel.dart';
// import 'package:my_thera/networkHandler.dart';
// import 'package:my_thera/screens/client/chatui/CustomUI/OwnMessageCard.dart';
// import 'package:my_thera/screens/client/chatui/CustomUI/ReplyCard.dart';
// import 'package:my_thera/screens/client/chatui/message.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class IndividualPage extends StatefulWidget {
//   IndividualPage({
//     Key? key,
//     required this.receiver,
//     required this.receiver_name,
//   }) : super(key: key);
//   final receiver;
//   final receiver_name;
//   @override
//   _IndividualPageState createState() => _IndividualPageState();
// }

// class _IndividualPageState extends State<IndividualPage> {
//   bool show = false;
//   bool isGroup = true;
//   FocusNode focusNode = FocusNode();
//   List<Message> messages = [];
//   bool sendButton = false;
//   TextEditingController _controller = TextEditingController();
//   ScrollController? _scrollController;
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//       new GlobalKey<RefreshIndicatorState>();
//   bool circular = true;
//   NetworkHandler networkHandler = NetworkHandler();
//   IO.Socket? socket;
//   String message = "";
//   ProfileModel profileModel = ProfileModel(
//     email: '',
//     firstname: '',
//     lastname: '',
//     middlename: '',
//     profileimage: '',
//     id: 0,
//   );

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

//   @override
//   void initState() {
//     _scrollController = ScrollController();
//     _scrollController!.addListener(_scrollListener);
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => _refreshIndicatorKey.currentState!.show());
//     super.initState();
//     setState(() {
//       fetchData();
//       fetchResult();
//     });
//     focusNode.addListener(() {
//       if (focusNode.hasFocus) {
//         setState(() {
//           show = false;
//         });
//       }
//     });
//     // connect();
//   }

//   _scrollListener() {
//     if (_scrollController!.offset >=
//             _scrollController!.position.maxScrollExtent &&
//         !_scrollController!.position.outOfRange) {
//       setState(() {
//         message = "reach the bottom";
//       });
//     }
//     if (_scrollController!.offset <=
//             _scrollController!.position.minScrollExtent &&
//         !_scrollController!.position.outOfRange) {
//       setState(() {
//         message = "reach the top";
//       });
//     }
//   }
//   // void connect() {
//   //   // MessageModel messageModel = MessageModel(sourceId: widget.sourceChat.id.toString(),targetId: );
//   //   socket = IO.io("http://192.168.0.106:5000", <String, dynamic>{
//   //     "transports": ["websocket"],
//   //     "autoConnect": false,
//   //   });
//   //   socket!.connect();
//   //   socket!.emit("signin", widget.receiver);
//   //   socket!.onConnect((data) {
//   //     print("Connected");
//   //     socket!.on("message", (msg) {
//   //       print(msg);
//   //       setMessage("destination", msg["message"]);
//   //       _scrollController.animateTo(_scrollController.position.maxScrollExtent,
//   //           duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
//   //     });
//   //   });
//   //   print(socket!.connected);
//   // }

//   // void sendMessage(String message, int sourceId, int targetId) {
//   //   setMessage("source", message);
//   //   socket!.emit("message",
//   //       {"message": message, "sourceId": sourceId, "targetId": targetId});
//   // }

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

//   // void setMessage(String type, String message) {
//   //   Message messageModel = Message(
//   //       message: message,
//   //       date: DateTime.now().toString().substring(10, 16),
//   //       read: false,
//   //       receiver: widget.receiver,
//   //       related: false,
//   //       sender: widget.receiver);
//   //   print(messages);

//   //   setState(() {
//   //     messages.add(messageModel);
//   //   });
//   // }
//   Future<Null> _refresh() {
//     return fetchResult().then((_user) {
//       List<Message> user;
//       setState(() => user = _user);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       key: _refreshIndicatorKey,
//       onRefresh: _refresh,
//       child: Stack(
//         children: [
//           Image.asset(
//             "assets/whatsapp_Back.png",
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             fit: BoxFit.cover,
//           ),
//           Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: PreferredSize(
//               preferredSize: const Size.fromHeight(60),
//               child: AppBar(
//                 leadingWidth: 70,
//                 titleSpacing: 0,
//                 leading: InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.arrow_back,
//                         size: 24,
//                       ),
//                       CircleAvatar(
//                         child: SvgPicture.asset(
//                           widget.receiver,
//                           color: Colors.white,
//                           height: 36,
//                           width: 36,
//                         ),
//                         radius: 20,
//                         backgroundColor: Colors.blueGrey,
//                       ),
//                     ],
//                   ),
//                 ),
//                 title: InkWell(
//                   onTap: () {},
//                   child: Container(
//                     margin: const EdgeInsets.all(6),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.receiver_name,
//                           style: const TextStyle(
//                             fontSize: 18.5,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const Text(
//                           "last seen today at 12:05",
//                           style: TextStyle(
//                             fontSize: 13,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 actions: [
//                   // IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
//                   // IconButton(icon: const Icon(Icons.call), onPressed: () {}),
//                   PopupMenuButton<String>(
//                     padding: const EdgeInsets.all(0),
//                     onSelected: (value) {
//                       print(value);
//                     },
//                     itemBuilder: (BuildContext contesxt) {
//                       return [
//                         const PopupMenuItem(
//                           child: Text("View Contact"),
//                           value: "View Contact",
//                         ),
//                         const PopupMenuItem(
//                           child: const Text("Media, links, and docs"),
//                           value: "Media, links, and docs",
//                         ),
//                         const PopupMenuItem(
//                           child: Text("Whatsapp Web"),
//                           value: "Whatsapp Web",
//                         ),
//                         const PopupMenuItem(
//                           child: Text("Search"),
//                           value: "Search",
//                         ),
//                         const PopupMenuItem(
//                           child: const Text("Mute Notification"),
//                           value: "Mute Notification",
//                         ),
//                         const PopupMenuItem(
//                           child: Text("Wallpaper"),
//                           value: "Wallpaper",
//                         ),
//                       ];
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             body: SizedBox(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: WillPopScope(
//                 child: Column(
//                   children: [
//                     FutureBuilder<List<Message>>(
//                         future: fetchResult(),
//                         builder: (context, snapshot) {
//                           if (snapshot.hasError) {
//                             return Text('Error: ${snapshot.error}');
//                           }

//                           if (snapshot.data == null) {
//                             return const CircularProgressIndicator();
//                           }

//                           return Expanded(
//                             // height: MediaQuery.of(context).size.height - 150,
//                             child: SingleChildScrollView(
//                               child: ListView.builder(
//                                 controller: _scrollController,
//                                 itemCount: snapshot.data!.length + 1,
//                                 physics: const ScrollPhysics(),
//                                 shrinkWrap: true,
//                                 //primary: true,
//                                 itemBuilder: (_, index) {
//                                   if (index == snapshot.data!.length) {
//                                     return Container(height: 70);
//                                   }
//                                   List<Message>? data = snapshot.data!;
//                                   return Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 8, bottom: 8),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           data[index].sender.id !=
//                                                   profileModel.id
//                                               ? CrossAxisAlignment.start
//                                               : CrossAxisAlignment.end,
//                                       children: [
//                                         SizedBox(
//                                           width: 300,
//                                           child: ListTile(
//                                             shape: RoundedRectangleBorder(
//                                               side: BorderSide(
//                                                 color: (data[index].sender.id !=
//                                                         profileModel.id
//                                                     ? const Color.fromARGB(
//                                                         255, 16, 16, 16)
//                                                     : const Color.fromARGB(
//                                                         255, 3, 141, 247)),
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             title: Text(
//                                               (data[index].message),
//                                               style: const TextStyle(
//                                                 fontSize: 15,
//                                               ),
//                                             ),
//                                             subtitle: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Container(
//                                                   width: 200,
//                                                   child: Text(
//                                                     (data[index].date),
//                                                     softWrap: true,
//                                                     style: const TextStyle(
//                                                       fontSize: 15,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           );
//                         }),
//                     Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Container(
//                         height: 70,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width - 60,
//                                   child: Card(
//                                     margin: const EdgeInsets.only(
//                                         left: 2, right: 2, bottom: 8),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(25),
//                                     ),
//                                     child: TextFormField(
//                                       controller: _controller,
//                                       focusNode: focusNode,
//                                       textAlignVertical:
//                                           TextAlignVertical.center,
//                                       keyboardType: TextInputType.multiline,
//                                       maxLines: 5,
//                                       minLines: 1,
//                                       onChanged: (value) {
//                                         if (value.length > 0) {
//                                           setState(() {
//                                             sendButton = true;
//                                           });
//                                         } else {
//                                           setState(() {
//                                             sendButton = false;
//                                           });
//                                         }
//                                       },
//                                       decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: "Type a message",
//                                         hintStyle:
//                                             const TextStyle(color: Colors.grey),
//                                         prefixIcon: IconButton(
//                                           icon: Icon(
//                                             show
//                                                 ? Icons.keyboard
//                                                 : Icons.emoji_emotions_outlined,
//                                           ),
//                                           onPressed: () {
//                                             if (!show) {
//                                               focusNode.unfocus();
//                                               focusNode.canRequestFocus = false;
//                                             }
//                                             setState(() {
//                                               show = !show;
//                                             });
//                                           },
//                                         ),
//                                         suffixIcon: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             IconButton(
//                                               icon:
//                                                   const Icon(Icons.attach_file),
//                                               onPressed: () {
//                                                 showModalBottomSheet(
//                                                     backgroundColor:
//                                                         Colors.transparent,
//                                                     context: context,
//                                                     builder: (builder) =>
//                                                         bottomSheet());
//                                               },
//                                             ),
//                                             IconButton(
//                                               icon:
//                                                   const Icon(Icons.camera_alt),
//                                               onPressed: () {
//                                                 // Navigator.push(
//                                                 //     context,
//                                                 //     MaterialPageRoute(
//                                                 //         builder: (builder) =>
//                                                 //             CameraApp()));
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                         contentPadding: const EdgeInsets.all(5),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                     bottom: 8,
//                                     right: 2,
//                                     left: 2,
//                                   ),
//                                   child: CircleAvatar(
//                                     radius: 25,
//                                     backgroundColor: const Color(0xFF128C7E),
//                                     child: IconButton(
//                                       icon: Icon(
//                                         sendButton ? Icons.send : Icons.mic,
//                                         color: Colors.white,
//                                       ),
//                                       onPressed: () async {
//                                         if (_controller.text.isNotEmpty) {
//                                           const storage =
//                                               FlutterSecureStorage();
//                                           var myJwt =
//                                               await storage.read(key: "jwt");
//                                           var clientid = await storage.read(
//                                               key: "client_id");
//                                           var cliniccode = await storage.read(
//                                               key: "clinic_code");
//                                           var senderid =
//                                               await storage.read(key: "userid");
//                                           var map = Map<String, String>();

//                                           map["message"] = _controller.text;
//                                           map["reciver"] = widget.receiver;
//                                           map["sender"] = "$senderid";
//                                           print(map);

//                                           final uri = Uri.parse(
//                                               'http://10.0.2.2:8000/api/v1/sendmessage/');
//                                           // final response = await http.post(
//                                           //   uri,
//                                           //   headers: {
//                                           //     'Authorization': 'JWT $myJwt',
//                                           //     'clinic_code': '$cliniccode',
//                                           //   },
//                                           //   body: map,
//                                           // );
//                                           Map<String, String> headers = {
//                                             'Authorization': 'JWT $myJwt',
//                                             'clinic_code': '$cliniccode',
//                                           };

//                                           var request =
//                                               http.MultipartRequest('POST', uri)
//                                                 ..fields.addAll(map);
//                                           request.headers.addAll(headers);
//                                           var response = await request.send();
//                                           if (response.statusCode == 200) {
//                                             final respStr = await response
//                                                 .stream
//                                                 .bytesToString();
//                                             final responseJson =
//                                                 json.decode(respStr);
//                                             // socketIO!.sendMessage(
//                                             //   'send_message',
//                                             //   json.encode({
//                                             //     'receiverChatID': receiverChatID,
//                                             //     'senderChatID': "$senderid",
//                                             //     'message': text,
//                                             //   }),
//                                             // );
//                                             _controller.clear();
//                                             //fetchResults();
//                                             print(responseJson);
//                                             _refreshIndicatorKey.currentState!
//                                                 .show();
//                                             // _scrollController.animateTo(
//                                             //     _scrollController
//                                             //         .position.maxScrollExtent,
//                                             //     duration: const Duration(
//                                             //         milliseconds: 300),
//                                             //     curve: Curves.easeOut);

//                                             // controller.animateTo(
//                                             //   0.0,
//                                             //   curve: Curves.easeOut,
//                                             //   duration: const Duration(milliseconds: 300),
//                                             // );
//                                           }
//                                         }

//                                         // if (sendButton) {
//                                         //   _scrollController.animateTo(
//                                         //       _scrollController
//                                         //           .position.maxScrollExtent,
//                                         //       duration: const Duration(
//                                         //           milliseconds: 300),
//                                         //       curve: Curves.easeOut);
//                                         //   sendMessage(_controller.text,
//                                         //       widget.receiver, profileModel.id);
//                                         //   _controller.clear();
//                                         //   setState(() {
//                                         //     sendButton = false;
//                                         //   });
//                                         // }
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             // show ? emojiSelect() : Container(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 onWillPop: () {
//                   if (show) {
//                     setState(() {
//                       show = false;
//                     });
//                   } else {
//                     Navigator.pop(context);
//                   }
//                   return Future.value(false);
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget bottomSheet() {
//     return Container(
//       height: 278,
//       width: MediaQuery.of(context).size.width,
//       child: Card(
//         margin: const EdgeInsets.all(18.0),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   iconCreation(
//                       Icons.insert_drive_file, Colors.indigo, "Document"),
//                   const SizedBox(
//                     width: 40,
//                   ),
//                   iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
//                   const SizedBox(
//                     width: 40,
//                   ),
//                   iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
//                 ],
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   iconCreation(Icons.headset, Colors.orange, "Audio"),
//                   const SizedBox(
//                     width: 40,
//                   ),
//                   iconCreation(Icons.location_pin, Colors.teal, "Location"),
//                   const SizedBox(
//                     width: 40,
//                   ),
//                   iconCreation(Icons.person, Colors.blue, "Contact"),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget iconCreation(IconData icons, Color color, String text) {
//     return InkWell(
//       onTap: () {},
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: color,
//             child: Icon(
//               icons,
//               // semanticLabel: "Help",
//               size: 29,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Text(
//             text,
//             style: const TextStyle(
//               fontSize: 12,
//               // fontWeight: FontWeight.w100,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget emojiSelect() {
//     return EmojiPicker(
//         rows: 4,
//         columns: 7,
//         onEmojiSelected: (emoji, category) {
//           print(emoji);
//           setState(() {
//             _controller.text = _controller.text + emoji.emoji;
//           });
//         });
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
//       message: json["message"] ?? "",
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
