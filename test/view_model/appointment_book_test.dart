import 'package:doctor_appointment_app/data/doctors.dart';
import 'package:doctor_appointment_app/model/appointment.dart';
import 'package:doctor_appointment_app/model/doctor.dart';
import 'package:doctor_appointment_app/utils/schedule.dart';
import 'package:doctor_appointment_app/view_model/appointment_book.dart';
import 'package:doctor_appointment_app/view_model/chat_log.dart';
import 'package:flutter_test/flutter_test.dart';

final now = DateTime(2026, 10, 15, 8);

/// A slot on [day] that no other patient has taken for [doctor].
DateTime freeSlot(Doctor doctor, DateTime day, {int skip = 0}) =>
    slotsOn(day).where((s) => !isTakenByOthers(doctor, s)).elementAt(skip);

void main() {
  late AppointmentBook book;
  final doctor = doctors[0];
  final other = doctors[1];
  final tomorrow = DateTime(2026, 10, 16);

  setUp(() => book = AppointmentBook(clock: () => now));

  test('books a free slot and lists it as upcoming', () {
    final slot = freeSlot(doctor, tomorrow);
    var notified = 0;
    book.addListener(() => notified++);

    expect(book.book(doctor, slot), BookingResult.booked);
    expect(book.upcoming, [Appointment(doctor: doctor, start: slot)]);
    expect(book.isAvailable(doctor, slot), isFalse);
    expect(notified, 1);
  });

  test('refuses past slots', () {
    expect(book.book(doctor, DateTime(2026, 10, 14, 9)), BookingResult.inPast);
    expect(book.upcoming, isEmpty);
  });

  test('refuses slots other patients have taken', () {
    final taken = [
      for (var d = 16; d < 30; d++) ...slotsOn(DateTime(2026, 10, d)),
    ].firstWhere((s) => isTakenByOthers(doctor, s));
    expect(book.book(doctor, taken), BookingResult.slotTaken);
  });

  test('refuses the same slot twice', () {
    final slot = freeSlot(doctor, tomorrow);
    book.book(doctor, slot);
    expect(book.book(doctor, slot), BookingResult.slotTaken);
  });

  test('refuses two doctors at the same time', () {
    final slot = slotsOn(tomorrow).firstWhere(
      (s) => !isTakenByOthers(doctor, s) && !isTakenByOthers(other, s),
    );
    book.book(doctor, slot);
    expect(book.book(other, slot), BookingResult.clash);
  });

  test('upcoming is sorted and drops appointments that have started', () {
    var clock = now;
    book = AppointmentBook(clock: () => clock);
    final later = freeSlot(doctor, DateTime(2026, 10, 17));
    final sooner = freeSlot(doctor, tomorrow);
    book.book(doctor, later);
    book.book(doctor, sooner);
    expect(book.upcoming.map((a) => a.start), [sooner, later]);

    clock = sooner.add(const Duration(minutes: 1));
    expect(book.upcoming.map((a) => a.start), [later]);
  });

  test('cancel and restore', () {
    final slot = freeSlot(doctor, tomorrow);
    book.book(doctor, slot);
    final appointment = book.upcoming.single;

    book.cancel(appointment);
    expect(book.upcoming, isEmpty);
    expect(book.isAvailable(doctor, slot), isTrue);

    book.restore(appointment);
    book.restore(appointment);
    expect(book.upcoming, [appointment]);
  });

  group('ChatLog', () {
    test('opens each thread with a greeting from the doctor', () {
      final chats = ChatLog(clock: () => now);
      final messages = chats.messagesWith(doctor);
      expect(messages, hasLength(1));
      expect(messages.single.fromMe, isFalse);
      expect(messages.single.text, contains(doctor.name));
    });

    test('sends trimmed messages and ignores blank ones', () {
      final chats = ChatLog(clock: () => now);
      expect(chats.send(doctor, '   '), isFalse);
      expect(chats.send(doctor, '  Hi doc  '), isTrue);
      expect(chats.lastMessageWith(doctor).text, 'Hi doc');
      expect(chats.lastMessageWith(doctor).fromMe, isTrue);
      expect(chats.messagesWith(other), hasLength(1));
    });
  });
}
