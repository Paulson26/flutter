// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:my_thera/networkHandler.dart';
// import 'package:my_thera/screens/client/profile/CreateProfile.dart';

// import 'MainProfile.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   NetworkHandler networkHandler = NetworkHandler();
//   Widget page = CircularProgressIndicator();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     checkProfile();
//   }

//   void checkProfile() async {
//     var response =
//         await networkHandler.get("http://10.0.2.2:8000/api/v1/user/");
//     if (response["status"] == true) {
//       setState(() {
//         page = MainProfile();
//       });
//     } else {
//       setState(() {
//         page = button();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(centerTitle: true, title: Text('Client Profile')),
//       body: page,
//     );
//   }

//   Widget showProfile() {
//     return Center(child: Text("Profile Data is Avalable"));
//   }

//   Widget button() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 70),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             "Tap to button to add profile data",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.deepOrange,
//               fontSize: 18,
//             ),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           InkWell(
//             onTap: () => {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => CreatProfile(
//                           firstname: profileModel.firstname,
//                           middlename: profileModel.middlename,
//                           lastname: profileModel.lastname)))
//             },
//             child: Container(
//               height: 60,
//               width: 150,
//               decoration: BoxDecoration(
//                 color: Colors.blueGrey,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Center(
//                 child: Text(
//                   "Add Proile",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
