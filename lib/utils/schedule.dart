import '../model/doctor.dart';

/// Start times offered every working day, as (hour, minute).
const slotTimes = <(int, int)>[
  (9, 0),
  (9, 30),
  (10, 0),
  (10, 30),
  (11, 0),
  (12, 0),
  (14, 0),
  (15, 30),
];

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Clinics are closed on Sundays.
bool isWorkingDay(DateTime day) => day.weekday != DateTime.sunday;

List<DateTime> slotsOn(DateTime day) => [
  for (final (hour, minute) in slotTimes)
    DateTime(day.year, day.month, day.day, hour, minute),
];

/// The next [count] working days, starting today if a slot is still open.
List<DateTime> upcomingWorkingDays(DateTime now, int count) {
  final days = <DateTime>[];
  var day = dateOnly(now);
  if (!isWorkingDay(day) || slotsOn(day).last.isBefore(now)) {
    day = DateTime(day.year, day.month, day.day + 1);
  }
  while (days.length < count) {
    if (isWorkingDay(day)) days.add(day);
    day = DateTime(day.year, day.month, day.day + 1);
  }
  return days;
}

/// Slots already filled by other patients. There is no server, so this is a
/// fixed pattern per doctor and day: the same slots stay taken between runs.
bool isTakenByOthers(Doctor doctor, DateTime start) {
  var hash = start.year * 372 + start.month * 31 + start.day;
  hash = hash * 31 + start.hour * 60 + start.minute;
  for (final unit in doctor.id.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  return hash % 4 == 0;
}
