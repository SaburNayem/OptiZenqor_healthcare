import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/appointment_controller/appointment_controller.dart';
import '../../symptom_checker/symptom_checker_controller/symptom_checker_controller.dart';
import '../data/history_service.dart';
import '../domain/history_item_model.dart';

final historyServiceProvider = Provider<HistoryService>((ref) {
  return HistoryService();
});

final historyProvider = FutureProvider<List<HistoryItemModel>>((ref) async {
  final service = ref.watch(historyServiceProvider);
  final appointments = ref.watch(appointmentControllerProvider).appointments;
  final symptomChecks = ref.watch(symptomCheckerControllerProvider).history;

  final appointmentItems = appointments
      .map(
        (item) => HistoryItemModel(
          title: 'Appointment with ${item.doctorName}',
          subtitle: '${item.specialization} - ${item.status}',
          dateTime: item.dateTime,
        ),
      )
      .toList();

  final symptomItems = symptomChecks
      .map(
        (item) => HistoryItemModel(
          title: 'Symptom check - ${item.urgency} urgency',
          subtitle: '${item.selectedSymptoms.length} symptoms selected',
          dateTime: item.checkedAt,
        ),
      )
      .toList();

  return service.mergeHistory(
    appointmentHistory: appointmentItems,
    symptomHistory: symptomItems,
  );
});
