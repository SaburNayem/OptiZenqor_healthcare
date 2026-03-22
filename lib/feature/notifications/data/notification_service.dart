import '../domain/notification_item_model.dart';

class NotificationService {
  Future<List<NotificationItemModel>> getNotifications({
    required int upcomingAppointments,
    required int completedAppointments,
    required int reportsWithAbnormalValues,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final items = <NotificationItemModel>[
      NotificationItemModel(
        id: 'n1',
        title: 'Appointment reminder',
        message: 'You have $upcomingAppointments upcoming appointment(s).',
        priority: upcomingAppointments > 0 ? 'HIGH' : 'LOW',
        type: 'appointment',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NotificationItemModel(
        id: 'n2',
        title: 'Follow-up reminder',
        message: completedAppointments > 0
            ? 'You have $completedAppointments completed appointment(s). Consider follow-up if symptoms persist.'
            : 'Track your symptoms and schedule a consultation if needed.',
        priority: 'MEDIUM',
        type: 'follow-up',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];

    if (reportsWithAbnormalValues > 0) {
      items.insert(
        0,
        NotificationItemModel(
          id: 'n3',
          title: 'Report attention needed',
          message:
              '$reportsWithAbnormalValues report(s) include abnormal markers. Consult a doctor for interpretation.',
          priority: 'HIGH',
          type: 'report',
          createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
        ),
      );
    }

    return items;
  }
}
