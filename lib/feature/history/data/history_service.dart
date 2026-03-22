import '../domain/history_item_model.dart';

class HistoryService {
  Future<List<HistoryItemModel>> mergeHistory({
    required List<HistoryItemModel> appointmentHistory,
    required List<HistoryItemModel> symptomHistory,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final merged = [...appointmentHistory, ...symptomHistory]
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return merged;
  }
}
