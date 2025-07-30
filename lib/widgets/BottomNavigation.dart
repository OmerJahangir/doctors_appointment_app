// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          label: "HH",
          icon: Icon(Icons.home_filled, color: Colors.blue),
        ),
        BottomNavigationBarItem(
          label: "HH",
          icon: Icon(Icons.calendar_month_rounded, color: Colors.black),
        ),
        BottomNavigationBarItem(
          label: "HH",
          icon: Icon(Icons.whatshot_outlined, color: Colors.black),
        ),
        BottomNavigationBarItem(
          label: "HH",
          icon: Icon(Icons.account_circle_outlined, color: Colors.black),
        ),
      ],
    );
  }
}
