// // ignore_for_file: prefer_interpolation_to_compose_strings

// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:connectivity/connectivity.dart';

// class JsonData extends StatelessWidget {
//   const JsonData({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: OnlineJsonData(),
//     );
//   }
// }

// class OnlineJsonData extends StatefulWidget {
//   const OnlineJsonData({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => CalendarExample();
// }

// class CalendarExample extends State<OnlineJsonData> {
//   final List<Color> _colorCollection = <Color>[];
//   String? _networkStatusMsg;
//   final Connectivity _internetConnectivity = Connectivity();
//   String currentDate = '';
//   List assessmentData = [];
//   @override
//   void initState() {
//     _initializeEventColor();
//     _checkNetworkStatus();
//     getDataFromWeb();
//     super.initState();
//     var today = DateTime.now();
//     var dateStr = DateFormat('yyyy-MM-dd');
//     currentDate = dateStr.format(today);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: getDataFromWeb(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.data != null) {
//             return SafeArea(
//               child: SfCalendar(
//                 view: CalendarView.day,
//                 initialDisplayDate: DateTime.now(),
//                 dataSource: MeetingDataSource(snapshot.data),
//                 allowDragAndDrop: true,
//               ),
//             );
//           } else {
//             return Center(
//               child: Text('$_networkStatusMsg'),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<List<Meeting>> getDataFromWeb() async {
//     const storage = FlutterSecureStorage();
//     var myJwt = await storage.read(key: "jwt");
//     var clientid = await storage.read(key: "client_id");

//     var cliniccode = await storage.read(key: "clinic_code");

//     final uri = Uri.parse('http://10.0.2.2:8000/api/v1/searchAppointment')
//         .replace(queryParameters: {
//       'clinic_code': cliniccode,
//       'client_id': clientid,
//       //'appt_date': currentDate
//     });
//     final response = await http.get(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'JWT $myJwt',
//         'clinic_code': '$cliniccode'
//       },
//     );

//     assessmentData = json.decode(response.body);

//     print(assessmentData);

//     final List<Meeting> appointmentData = [];
//     final Random random = Random();
//     String date = '';
//     String date1 = '';
//     for (var i = 0; i < assessmentData.length; i++) {
//       date =
//           "${assessmentData[i]['appt_date']} ${assessmentData[i]['appt_from_time']}";
//       date1 =
//           "${assessmentData[i]['appt_date']} ${assessmentData[i]['appt_to_time'] ?? "00:00:00"}";

//       Meeting meetingData = Meeting(
//           eventName: assessmentData[i]['appt_purpose'].toString(),
//           from: DateFormat('yyyy-MM-dd HH:mm:ss').parse(date.toString()),
//           to: DateFormat('yyyy-MM-dd HH:mm:ss').parse(date1.toString()),
//           background: _colorCollection[random.nextInt(9)],
//           allDay: false);
//       appointmentData.add(meetingData);
//     }
//     return appointmentData;
//   }

//   DateTime _convertDateFromString(String date) {
//     return DateTime.parse(date);
//   }

//   void _initializeEventColor() {
//     _colorCollection.add(const Color(0xFF0F8644));
//     _colorCollection.add(const Color(0xFF8B1FA9));
//     _colorCollection.add(const Color(0xFFD20100));
//     _colorCollection.add(const Color(0xFFFC571D));
//     _colorCollection.add(const Color(0xFF36B37B));
//     _colorCollection.add(const Color(0xFF01A1EF));
//     _colorCollection.add(const Color(0xFF3D4FB5));
//     _colorCollection.add(const Color(0xFFE47C73));
//     _colorCollection.add(const Color(0xFF636363));
//     _colorCollection.add(const Color(0xFF0A8043));
//   }

//   void _checkNetworkStatus() {
//     _internetConnectivity.onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       setState(() {
//         _networkStatusMsg = result.toString();
//         if (_networkStatusMsg == "ConnectivityResult.mobile") {
//           _networkStatusMsg =
//               "You are connected to mobile network, loading calendar data ....";
//         } else if (_networkStatusMsg == "ConnectivityResult.wifi") {
//           _networkStatusMsg =
//               "You are connected to wifi network, loading calendar data ....";
//         } else {
//           _networkStatusMsg =
//               "Internet connection may not be available. Connect to another network";
//         }
//       });
//     });
//   }
// }

// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Meeting> source) {
//     appointments = source;
//   }

//   @override
//   DateTime getStartTime(int index) {
//     return appointments![index].from;
//   }

//   @override
//   DateTime getEndTime(int index) {
//     return appointments![index].to;
//   }

//   @override
//   String getSubject(int index) {
//     return appointments![index].eventName;
//   }

//   @override
//   Color getColor(int index) {
//     return appointments![index].background;
//   }

//   @override
//   bool isAllDay(int index) {
//     return appointments![index].allDay;
//   }
// }

// class Meeting {
//   Meeting(
//       {this.eventName,
//       this.from,
//       this.to,
//       this.background,
//       this.allDay = false});

//   String? eventName;
//   DateTime? from;
//   DateTime? to;
//   Color? background;
//   bool? allDay;
// }
