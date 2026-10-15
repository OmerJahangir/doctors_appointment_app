import 'package:flutter/foundation.dart';

import '../model/appointment.dart';
import '../model/doctor.dart';
import '../utils/schedule.dart';

/// The user's appointments. Lives for the whole app session (nothing is
/// persisted between launches).
class AppointmentBook extends ChangeNotifier {
  AppointmentBook({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final _appointments = <Appointment>[];

  DateTime now() => _clock();

  /// Appointments that have not started yet, soonest first.
  List<Appointment> get upcoming {
    final current = _clock();
    return _appointments.where((a) => a.start.isAfter(current)).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }

  /// Whether [doctor] can still be booked at [start].
  bool isAvailable(Doctor doctor, DateTime start) =>
      start.isAfter(_clock()) &&
      !isTakenByOthers(doctor, start) &&
      !_appointments.any((a) => a.doctor == doctor && a.start == start);

  bool hasAppointmentAt(DateTime start) =>
      _appointments.any((a) => a.start == start);

  BookingResult book(Doctor doctor, DateTime start) {
    if (!start.isAfter(_clock())) return BookingResult.inPast;
    if (!isAvailable(doctor, start)) return BookingResult.slotTaken;
    if (hasAppointmentAt(start)) return BookingResult.clash;
    _appointments.add(Appointment(doctor: doctor, start: start));
    notifyListeners();
    return BookingResult.booked;
  }

  void cancel(Appointment appointment) {
    if (_appointments.remove(appointment)) notifyListeners();
  }

  /// Puts back an appointment removed by [cancel], for "Undo".
  void restore(Appointment appointment) {
    if (_appointments.contains(appointment)) return;
    _appointments.add(appointment);
    notifyListeners();
  }
}
