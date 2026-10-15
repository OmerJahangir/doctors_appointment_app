import 'doctor.dart';

class Appointment {
  const Appointment({required this.doctor, required this.start});

  final Doctor doctor;
  final DateTime start;

  @override
  bool operator ==(Object other) =>
      other is Appointment && other.doctor == doctor && other.start == start;

  @override
  int get hashCode => Object.hash(doctor, start);
}

/// Why a booking attempt did or did not go through.
enum BookingResult {
  booked,

  /// Another patient already has this slot.
  slotTaken,

  /// The slot has already started.
  inPast,

  /// The user already has an appointment at this time.
  clash,
}
