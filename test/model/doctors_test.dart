import 'package:doctor_appointment_app/data/doctors.dart';
import 'package:doctor_appointment_app/model/doctor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('doctor ids are unique', () {
    expect(doctors.map((d) => d.id).toSet(), hasLength(doctors.length));
  });

  test('every specialty has at least one doctor', () {
    for (final specialty in Specialty.values) {
      expect(doctors.where((d) => d.specialty == specialty), isNotEmpty);
    }
  });

  group('searchDoctors', () {
    test('empty query returns everyone', () {
      expect(searchDoctors(doctors), doctors);
      expect(searchDoctors(doctors, query: '   '), doctors);
    });

    test('matches name or title, ignoring case', () {
      expect(searchDoctors(doctors, query: 'ayesha').map((d) => d.id), [
        'ayesha-khan',
      ]);
      expect(searchDoctors(doctors, query: 'CARDI').map((d) => d.id), [
        'ayesha-khan',
        'mei-lin',
      ]);
    });

    test('filters by specialty and query together', () {
      final result = searchDoctors(
        doctors,
        query: 'dr',
        specialty: Specialty.infection,
      );
      expect(result.every((d) => d.specialty == Specialty.infection), isTrue);
      expect(result, isNotEmpty);
    });

    test('returns nothing when nothing matches', () {
      expect(searchDoctors(doctors, query: 'dentist'), isEmpty);
    });
  });
}
