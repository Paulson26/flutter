// ignore_for_file: unused_field, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:my_thera/screens/client/appointment/appointment_view.dart';
import 'package:my_thera/screens/client/appointment/test.dart';
import 'package:my_thera/screens/client/calendar/calendar.dart';
import 'package:my_thera/screens/client/chatui/clinician_admin_list/topbar_view.dart';
import 'package:my_thera/screens/client/feedback/dropdown.dart';
import 'package:my_thera/screens/bottom_navigation.dart';
import 'package:my_thera/screens/client/dashboard.dart';
import 'package:my_thera/screens/client/documents.dart';
import 'package:my_thera/screens/client/feedback_review.dart';
import 'package:my_thera/screens/client/help_desk.dart';
import 'package:my_thera/screens/client/password_change.dart';
import 'package:my_thera/screens/client/payment/biiling_payment.dart';
import 'package:my_thera/screens/client/profile/MainProfile.dart';
import 'package:my_thera/screens/client/waiting_room/pending.dart';
import 'package:my_thera/screens/client/waiting_room/waiting_room.dart';
import 'package:my_thera/screens/colors/colors.dart';
import 'package:my_thera/screens/login/login_page.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    Key? key,
    required this.appt,
  }) : super(key: key);
  late var appt;

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  String currentDate = "";

  var _pages;
  @override
  void initState() {
    var today = DateTime.now();
    var dateStr = DateFormat('yyyy-MM-dd');
    currentDate = dateStr.format(today);
    _pages = [
      HomePage(),
      JsonDataGrid(),
      WaitingRoom(
        apptdate: null,
      ),
      Billinf()
    ];

    super.initState();
  }

  // ignore: prefer_final_fields

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
          height: 60,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainProfile()),
            );
          },
          icon: Icon(Icons.person),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatWith()),
              );
            },
            icon: Icon(Icons.question_answer),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.black,
              iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
              textTheme: TextTheme().apply(bodyColor: Colors.white),
            ),
            child: PopupMenuButton<int>(
              position: PopupMenuPosition.under,
              color: Colors.black,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('Sessions'),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text('Calendar'),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text('Documents'),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Text('Settings'),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  child: Text('Help'),
                ),
                PopupMenuItem<int>(
                  value: 5,
                  child: Text('Feedback'),
                ),
                PopupMenuItem<int>(
                  value: 6,
                  child: Text('Change Password'),
                ),
                PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 7,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text('Log Out'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: primaryBlack,
      body: ValueListenableBuilder(
        valueListenable: indexChange,
        builder: (context, int index, _) {
          return _pages[index];
        },
      ),
      bottomNavigationBar: BottomNav(),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AppointmentPage()),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => JsonData()),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DocumentPage()),
        );
        break;
      case 3:
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (context) => Submitforinsurenceapproval(
        //             apptid: 16,
        //             client_id: 3,
        //             insurence_reject_comment: 'hello',
        //           )),
        // );
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HelpAndSupport()),
        );
        break;
      case 5:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ReviewsDemo()),
        );
        break;
      case 6:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyStatefulWidget()),
        );
        break;

      case 7:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
    }
  }
}
