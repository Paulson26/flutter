import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_thera/screens/client/chatui/clinician_admin_list/clinic_admin_view.dart';
import 'package:my_thera/screens/client/chatui/clinician_admin_list/clinician_view.dart';
import 'package:my_thera/screens/client/chatui/list_clinician_clinic.dart';

class ChatWith extends StatefulWidget {
  @override
  _ChatWithState createState() => _ChatWithState();
}

class _ChatWithState extends State<ChatWith> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.person),
                text: " Clinician",
              ),
              Tab(icon: Icon(Icons.admin_panel_settings), text: "Clinic Admin"),
            ],
          ),
          title: const Text('Chat With'),
        ),
        body: TabBarView(
          children: [
            Center(child: Chat()),
            Center(child: Chat7()),
          ],
        ),
      ),
    );
  }
}
