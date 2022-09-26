// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ValueNotifier<int> indexChange = ValueNotifier(0);

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: indexChange,
      builder: (context, int newIndex, _) {
        return BottomNavigationBar(
          currentIndex: newIndex,
          onTap: (index) {
            indexChange.value = index;
          },
          elevation: 0,
          iconSize: 35,
          selectedLabelStyle:
              TextStyle(fontStyle: FontStyle.italic, fontFamily: 'Roboto'),
          type: BottomNavigationBarType.shifting,
          backgroundColor: Color.fromARGB(255, 9, 123, 237),
          selectedItemColor: Color.fromARGB(255, 14, 14, 14),
          unselectedItemColor: Color.fromARGB(255, 255, 250, 250),
          selectedIconTheme:
              const IconThemeData(color: Color.fromARGB(255, 4, 4, 4)),
          unselectedIconTheme:
              const IconThemeData(color: Color.fromARGB(255, 12, 12, 12)),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services_sharp),
              label: 'Appointment',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Waiting Room'),
            BottomNavigationBarItem(
                icon: Icon(Icons.payment), label: 'Billing'),
          ],
        );
      },
    );
  }
}
