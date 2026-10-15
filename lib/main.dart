import 'package:flutter/material.dart';

import 'res/app_theme.dart';
import 'view/splash/splash_screen.dart';
import 'view_model/app_scope.dart';
import 'view_model/appointment_book.dart';
import 'view_model/chat_log.dart';

void main() {
  runApp(DoctorAppointmentApp());
}

class DoctorAppointmentApp extends StatelessWidget {
  DoctorAppointmentApp({
    super.key,
    AppointmentBook? appointments,
    ChatLog? chats,
    this.home = const SplashScreen(),
  }) : appointments = appointments ?? AppointmentBook(),
       chats = chats ?? ChatLog();

  final AppointmentBook appointments;
  final ChatLog chats;
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      appointments: appointments,
      chats: chats,
      child: MaterialApp(
        title: 'Doctor Appointment',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: home,
      ),
    );
  }
}
