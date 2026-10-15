import '../model/doctor.dart';

/// Sample doctors shown throughout the app. There is no backend; this list
/// is the whole directory.
const doctors = <Doctor>[
  Doctor(
    id: 'ayesha-khan',
    name: 'Dr. Ayesha Khan',
    title: 'Cardiologist',
    specialty: Specialty.heart,
    image: 'assets/images/doctor2.png',
    rating: 4.9,
    patients: 1240,
    experienceYears: 12,
    distanceKm: 1.2,
    bio:
        'Dr. Khan treats heart rhythm problems, high blood pressure and '
        'heart failure. She runs the outpatient cardiac clinic and focuses on '
        'prevention: most of her patients leave with a plan they can follow '
        'at home rather than a longer prescription list.',
  ),
  Doctor(
    id: 'daniel-carter',
    name: 'Dr. Daniel Carter',
    title: 'Infectious Disease Specialist',
    specialty: Specialty.infection,
    image: 'assets/images/doctor3.png',
    rating: 4.7,
    patients: 860,
    experienceYears: 9,
    distanceKm: 2.8,
    bio:
        'Dr. Carter diagnoses and treats viral, bacterial and fungal '
        'infections, including travel-related illness. He also advises on '
        'vaccinations before trips abroad.',
  ),
  Doctor(
    id: 'emily-brooks',
    name: 'Dr. Emily Brooks',
    title: 'Family Physician',
    specialty: Specialty.medicine,
    image: 'assets/images/doctor4.png',
    rating: 4.8,
    patients: 2100,
    experienceYears: 15,
    distanceKm: 0.6,
    bio:
        'Dr. Brooks looks after patients of every age, from routine check-ups '
        'to long-term conditions such as diabetes and asthma, and refers to '
        'specialists when needed.',
  ),
  Doctor(
    id: 'hannah-lewis',
    name: 'Dr. Hannah Lewis',
    title: 'Allergist & Immunologist',
    specialty: Specialty.medicine,
    image: 'assets/images/doctor5.png',
    rating: 4.6,
    patients: 540,
    experienceYears: 7,
    distanceKm: 3.4,
    bio:
        'Dr. Lewis tests for and manages food, pollen and drug allergies, '
        'and treats immune conditions that cause recurring infections.',
  ),
  Doctor(
    id: 'ryan-mitchell',
    name: 'Dr. Ryan Mitchell',
    title: 'General Physician',
    specialty: Specialty.medicine,
    image: 'assets/images/doctor6.png',
    rating: 4.5,
    patients: 1530,
    experienceYears: 10,
    distanceKm: 1.9,
    bio:
        'Dr. Mitchell handles everyday illness and injuries, prescriptions '
        'and sick notes, and is usually the quickest doctor to get a same-day '
        'slot with.',
  ),
  Doctor(
    id: 'lucas-bennett',
    name: 'Dr. Lucas Bennett',
    title: 'Pulmonologist',
    specialty: Specialty.infection,
    image: 'assets/images/doctor1.png',
    rating: 4.7,
    patients: 690,
    experienceYears: 11,
    distanceKm: 4.1,
    bio:
        'Dr. Bennett treats lung and airway conditions, including chest '
        'infections, asthma and long-term coughs, and runs lung function '
        'tests in clinic.',
  ),
  Doctor(
    id: 'mei-lin',
    name: 'Dr. Mei Lin',
    title: 'Cardiac Surgeon',
    specialty: Specialty.heart,
    image: 'assets/images/doctor7.png',
    rating: 4.9,
    patients: 410,
    experienceYears: 14,
    distanceKm: 5.0,
    bio:
        'Dr. Lin performs valve repair and bypass surgery and sees patients '
        'for consultations before and after their operation.',
  ),
];

/// Doctors whose name or title contains [query] and, when [specialty] is set,
/// who belong to that group.
List<Doctor> searchDoctors(
  List<Doctor> source, {
  String query = '',
  Specialty? specialty,
}) {
  final needle = query.trim().toLowerCase();
  return [
    for (final doctor in source)
      if ((specialty == null || doctor.specialty == specialty) &&
          (needle.isEmpty ||
              doctor.name.toLowerCase().contains(needle) ||
              doctor.title.toLowerCase().contains(needle)))
        doctor,
  ];
}
