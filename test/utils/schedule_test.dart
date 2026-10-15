import 'package:doctor_appointment_app/data/doctors.dart';
import 'package:doctor_appointment_app/utils/date_format.dart';
import 'package:doctor_appointment_app/utils/schedule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatTime', () {
    test('pads hours and uses 12-hour clock', () {
      expect(formatTime(DateTime(2026, 1, 1, 9, 5)), '09:05 AM');
      expect(formatTime(DateTime(2026, 1, 1, 12)), '12:00 PM');
      expect(formatTime(DateTime(2026, 1, 1, 0, 30)), '12:30 AM');
      expect(formatTime(DateTime(2026, 1, 1, 15, 30)), '03:30 PM');
    });
  });

  test('formatDay', () {
    expect(formatDay(DateTime(2026, 10, 15)), 'Thu, 15 Oct');
  });

  group('upcomingWorkingDays', () {
    test('starts today while a slot is still open', () {
      final now = DateTime(2026, 10, 15, 8); // Thursday morning
      expect(upcomingWorkingDays(now, 3), [
        DateTime(2026, 10, 15),
        DateTime(2026, 10, 16),
        DateTime(2026, 10, 17),
      ]);
    });

    test('skips today after the last slot, and skips Sundays', () {
      final now = DateTime(2026, 10, 17, 18); // Saturday evening
      expect(upcomingWorkingDays(now, 2), [
        DateTime(2026, 10, 19),
        DateTime(2026, 10, 20),
      ]);
    });
  });

  test('slotsOn returns every slot time on that day', () {
    final slots = slotsOn(DateTime(2026, 10, 15));
    expect(slots, hasLength(slotTimes.length));
    expect(slots.first, DateTime(2026, 10, 15, 9));
    expect(slots.every((s) => s.day == 15), isTrue);
  });

  test('isTakenByOthers is stable and leaves most slots free', () {
    final doctor = doctors.first;
    final slots = [
      for (var d = 0; d < 30; d++) ...slotsOn(DateTime(2026, 11, 1 + d)),
    ];
    final taken = slots.where((s) => isTakenByOthers(doctor, s)).toList();
    expect(taken, isNotEmpty);
    expect(taken.length, lessThan(slots.length / 2));
    expect(slots.where((s) => isTakenByOthers(doctor, s)).toList(), taken);
  });
}
