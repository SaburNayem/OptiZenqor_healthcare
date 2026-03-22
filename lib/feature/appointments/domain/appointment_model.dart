class AppointmentModel {
  const AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.dateTime,
    this.isCancelled = false,
  });

  final String id;
  final String doctorId;
  final String doctorName;
  final String specialization;
  final DateTime dateTime;
  final bool isCancelled;

  String get status {
    if (isCancelled) {
      return 'cancelled';
    }
    final now = DateTime.now();
    final end = dateTime.add(const Duration(minutes: 45));
    if (now.isBefore(dateTime)) {
      return 'upcoming';
    }
    if (now.isAfter(dateTime) && now.isBefore(end)) {
      return 'ongoing';
    }
    return 'completed';
  }
}
