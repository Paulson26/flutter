// import 'package:flutter/material.dart';
// import 'package:my_thera/screens/calendar/calendar_view_page.dart';
// import 'package:my_thera/screens/client/feedback_review.dart';
// import 'package:my_thera/screens/client/help_desk.dart';
// import 'package:my_thera/screens/login/login_page.dart';
// import 'package:my_thera/screens/message/chat.dart';
// import 'package:my_thera/screens/settings/profile_update.dart';
// import 'package:my_thera/screens/settings/settings.dart';
// import 'package:my_thera/screens/appointment/list_Appointment.dart';

// class Appbarn extends StatelessWidget with PreferredSizeWidget {
//   const Appbarn({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       centerTitle: true,
//       title: Text('Theralogic'),
//       leading: IconButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ProfileUpdate()),
//           );
//         },
//         icon: Icon(Icons.person),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const Chat()),
//             );
//           },
//           icon: Icon(Icons.question_answer),
//         ),
//         Theme(
//           data: Theme.of(context).copyWith(
//             dividerColor: Colors.black,
//             iconTheme: IconThemeData(color: Colors.black),
//             textTheme: TextTheme().apply(bodyColor: Colors.white),
//           ),
//           child: PopupMenuButton<int>(
//             position: PopupMenuPosition.under,
//             color: Colors.black,
//             onSelected: (item) => onSelected(context, item),
//             itemBuilder: (context) => [
//               PopupMenuItem<int>(
//                 value: 0,
//                 child: Text('Sessions'),
//               ),
//               PopupMenuItem<int>(
//                 value: 1,
//                 child: Text('Calendar'),
//               ),
//               PopupMenuItem<int>(
//                 value: 2,
//                 child: Text('Documents'),
//               ),
//               PopupMenuItem<int>(
//                 value: 3,
//                 child: Text('Settings'),
//               ),
//               PopupMenuItem<int>(
//                 value: 4,
//                 child: Text('Help'),
//               ),
//               PopupMenuItem<int>(
//                 value: 5,
//                 child: Text('Feedback'),
//               ),
//               PopupMenuDivider(),
//               PopupMenuItem<int>(
//                 value: 6,
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.logout,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(width: 8),
//                     Text('Log Out'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
//   void onSelected(BuildContext context, int item) {
//     switch (item) {
//       case 0:
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => MyHome2Page()),
//         );
//         break;
//       case 1:
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => CalendarViewPage()),
//         );
//         break;
//       case 2:
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => Settings()),
//         );
//         break;
//       case 3:
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => Settings()),
//         );
//         break;
//       case 4:
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => HelpAndSupport()),
//         );
//         break;
//       case 5:
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => ReviewsDemo()),
//         );
//         break;

//       case 6:
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => LoginPage()),
//           (route) => false,
//         );
//     }
//   }
// }
