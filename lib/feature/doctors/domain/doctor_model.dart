class DoctorModel {
  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.experienceYears,
    required this.isAvailableNow,
    required this.nextAvailable,
  });

  final String id;
  final String name;
  final String specialization;
  final double rating;
  final int experienceYears;
  final bool isAvailableNow;
  final String nextAvailable;
}
