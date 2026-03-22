import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/report_service.dart';
import '../domain/report_model.dart';

final reportServiceProvider = Provider<ReportService>((ref) {
  return ReportService();
});

class ReportState {
  const ReportState({
    this.reports = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<ReportModel> reports;
  final bool isLoading;
  final String? errorMessage;

  ReportState copyWith({
    List<ReportModel>? reports,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReportState(
      reports: reports ?? this.reports,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class ReportController extends StateNotifier<ReportState> {
  ReportController(this._service) : super(const ReportState()) {
    loadReports();
  }

  final ReportService _service;

  Future<void> loadReports() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final reports = await _service.fetchReports();
      state = state.copyWith(reports: reports, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Could not load reports');
    }
  }

  Future<bool> uploadReport({required String fileName, required String fileType}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _service.uploadReport(fileName: fileName, fileType: fileType);
      final reports = await _service.fetchReports();
      state = state.copyWith(reports: reports, isLoading: false);
      return true;
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Upload failed');
      return false;
    }
  }
}

final reportControllerProvider = StateNotifierProvider<ReportController, ReportState>((ref) {
  return ReportController(ref.watch(reportServiceProvider));
});
