/// Broad groups used by the category filter on the home screen.
enum Specialty {
  medicine('Medicine', 'assets/images/capsule.png'),
  infection('Infection', 'assets/images/virus.png'),
  heart('Heart', 'assets/images/heart.png');

  const Specialty(this.label, this.iconAsset);

  final String label;
  final String iconAsset;
}

class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.title,
    required this.specialty,
    required this.image,
    required this.rating,
    required this.patients,
    required this.experienceYears,
    required this.distanceKm,
    required this.bio,
  });

  final String id;
  final String name;

  /// What the doctor practises, e.g. "Cardiologist".
  final String title;
  final Specialty specialty;
  final String image;

  /// Average review score out of 5.
  final double rating;
  final int patients;
  final int experienceYears;
  final double distanceKm;
  final String bio;

  @override
  bool operator ==(Object other) => other is Doctor && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
