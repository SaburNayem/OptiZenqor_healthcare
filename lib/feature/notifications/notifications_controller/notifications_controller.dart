import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/appointment_controller/appointment_controller.dart';
import '../../reports/report_controller/report_controller.dart';
import '../data/notification_service.dart';
import '../domain/notification_item_model.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final notificationsProvider = FutureProvider<List<NotificationItemModel>>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  final appointments = ref.watch(appointmentControllerProvider).appointments;
  final reports = ref.watch(reportControllerProvider).reports;
  final upcoming = appointments.where((item) => item.status == 'upcoming').length;
  final completed = appointments.where((item) => item.status == 'completed').length;
  final abnormalReports = reports.where((item) => item.abnormalFindings.isNotEmpty).length;
  return service.getNotifications(
    upcomingAppointments: upcoming,
    completedAppointments: completed,
    reportsWithAbnormalValues: abnormalReports,
  );
});
