import '../domain/appointment_model.dart';

class AppointmentService {
  final List<AppointmentModel> _appointments = [];

  static const List<String> _dailySlots = <String>[
    '09:00',
    '10:00',
    '11:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  Future<List<AppointmentModel>> fetchAppointments() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return List<AppointmentModel>.from(_appointments)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<AppointmentModel> bookAppointment({
    required String doctorId,
    required String doctorName,
    required String specialization,
    required DateTime dateTime,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final appointment = AppointmentModel(
      id: 'ap-${DateTime.now().millisecondsSinceEpoch}',
      doctorId: doctorId,
      doctorName: doctorName,
      specialization: specialization,
      dateTime: dateTime,
    );
    _appointments.add(appointment);
    return appointment;
  }

  Future<List<String>> fetchAvailableSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final usedSlots = _appointments
        .where(
          (item) =>
              item.doctorId == doctorId &&
              item.dateTime.year == date.year &&
              item.dateTime.month == date.month &&
              item.dateTime.day == date.day &&
              !item.isCancelled,
        )
        .map((item) =>
            '${item.dateTime.hour.toString().padLeft(2, '0')}:${item.dateTime.minute.toString().padLeft(2, '0')}')
        .toSet();

    return _dailySlots.where((slot) => !usedSlots.contains(slot)).toList();
  }
}
