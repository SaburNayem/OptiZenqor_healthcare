import '../domain/doctor_model.dart';

class DoctorService {
  final List<DoctorModel> _doctors = const [
    DoctorModel(
      id: 'd1',
      name: 'Dr. Olivia Green',
      specialization: 'Cardiologist',
      rating: 4.8,
      experienceYears: 14,
      isAvailableNow: true,
      nextAvailable: 'Today, 4:30 PM',
    ),
    DoctorModel(
      id: 'd2',
      name: 'Dr. Ethan Ward',
      specialization: 'General Physician',
      rating: 4.6,
      experienceYears: 10,
      isAvailableNow: true,
      nextAvailable: 'Today, 6:00 PM',
    ),
    DoctorModel(
      id: 'd3',
      name: 'Dr. Mia Harper',
      specialization: 'Pulmonologist',
      rating: 4.7,
      experienceYears: 11,
      isAvailableNow: false,
      nextAvailable: 'Tomorrow, 10:00 AM',
    ),
    DoctorModel(
      id: 'd4',
      name: 'Dr. Lucas Ahmed',
      specialization: 'Neurologist',
      rating: 4.5,
      experienceYears: 9,
      isAvailableNow: false,
      nextAvailable: 'Tomorrow, 11:45 AM',
    ),
  ];

  Future<List<DoctorModel>> fetchDoctors() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return _doctors;
  }
}
