import 'package:doctor_appointment_app/data/doctors.dart';
import 'package:doctor_appointment_app/main.dart';
import 'package:doctor_appointment_app/utils/date_format.dart';
import 'package:doctor_appointment_app/utils/schedule.dart';
import 'package:doctor_appointment_app/view/shell/home_shell.dart';
import 'package:doctor_appointment_app/view/splash/splash_screen.dart';
import 'package:doctor_appointment_app/view_model/appointment_book.dart';
import 'package:doctor_appointment_app/view_model/chat_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Thursday morning, before the first slot.
final now = DateTime(2026, 10, 15, 8);

void main() {
  late AppointmentBook book;
  late ChatLog chats;

  Future<void> pumpApp(
    WidgetTester tester, {
    Widget home = const HomeShell(),
  }) async {
    // A tall phone, so long lists fit without scrolling in most tests.
    tester.view.physicalSize = const Size(1290, 2796);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    book = AppointmentBook(clock: () => now);
    chats = ChatLog(clock: () => now);
    await tester.pumpWidget(
      DoctorAppointmentApp(appointments: book, chats: chats, home: home),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('splash leads to the home screen', (tester) async {
    await pumpApp(tester, home: const SplashScreen());

    expect(find.text('Complete\nHealth\nSolution'), findsOneWidget);
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Our Doctors'), findsOneWidget);
    expect(find.text('Giovanny'), findsOneWidget);
  });

  testWidgets('search and category filter the doctor list', (tester) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField), 'brooks');
    await tester.pumpAndSettle();
    expect(find.text('Dr. Emily Brooks'), findsOneWidget);
    expect(find.text('Dr. Ayesha Khan'), findsNothing);

    await tester.enterText(find.byType(TextField), 'nobody');
    await tester.pumpAndSettle();
    expect(find.text('No doctors match your search'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Heart'));
    await tester.pumpAndSettle();
    expect(find.text('Dr. Ayesha Khan'), findsOneWidget);
    expect(find.text('Dr. Mei Lin'), findsOneWidget);
    expect(find.text('Dr. Emily Brooks'), findsNothing);
  });

  testWidgets('the live banner can be dismissed', (tester) async {
    await pumpApp(tester);
    expect(find.textContaining('live stream'), findsOneWidget);
    await tester.tap(find.byTooltip('Dismiss'));
    await tester.pumpAndSettle();
    expect(find.textContaining('live stream'), findsNothing);
  });

  testWidgets('book, see and cancel an appointment', (tester) async {
    await pumpApp(tester);
    final doctor = doctors.first;
    final slot = slotsOn(
      DateTime(2026, 10, 15),
    ).firstWhere((s) => !isTakenByOthers(doctor, s));

    await tester.tap(find.text(doctor.name));
    await tester.pumpAndSettle();
    expect(find.text(doctor.bio), findsOneWidget);

    await tester.tap(find.text('Make an appointment'));
    await tester.pumpAndSettle();
    expect(find.text('Pick a time'), findsOneWidget);

    await tester.ensureVisible(find.text(formatTime(slot)));
    await tester.tap(find.text(formatTime(slot)));
    await tester.pumpAndSettle();
    final bookLabel = 'Book ${formatTime(slot)}, ${formatDay(slot)}';
    await tester.ensureVisible(find.text(bookLabel));
    await tester.tap(find.text(bookLabel));
    await tester.pumpAndSettle();

    expect(find.text('Appointment booked'), findsOneWidget);
    expect(book.upcoming.single.start, slot);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    // Back on the doctor's profile.
    expect(find.text('Make an appointment'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('Appointments')).last);
    await tester.pumpAndSettle();
    expect(find.text(formatTime(slot)), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('No upcoming appointments'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text(formatTime(slot)), findsOneWidget);
  });

  testWidgets('taken slots cannot be picked', (tester) async {
    await pumpApp(tester);
    final doctor = doctors.first;
    final taken = slotsOn(
      DateTime(2026, 10, 15),
    ).where((s) => isTakenByOthers(doctor, s));

    await tester.tap(find.text(doctor.name));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Make an appointment'));
    await tester.pumpAndSettle();

    expect(find.text('Unavailable'), findsNWidgets(taken.length));
    for (final slot in taken) {
      await tester.ensureVisible(find.text(formatTime(slot)));
      await tester.tap(find.text(formatTime(slot)));
      await tester.pumpAndSettle();
      expect(find.text('Pick a time'), findsOneWidget);
    }
  });

  testWidgets('messages can be sent from the chat screen', (tester) async {
    await pumpApp(tester);
    final doctor = doctors[1];

    await tester.tap(find.byKey(const ValueKey('Messages')).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(doctor.name));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Is Friday okay?');
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();

    expect(find.text('Is Friday okay?'), findsOneWidget);
    expect(chats.lastMessageWith(doctor).text, 'Is Friday okay?');

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('You: Is Friday okay?'), findsOneWidget);
  });
}
