import '../domain/report_model.dart';

class ReportService {
  final List<ReportModel> _reports = [];

  String _detectReportType(String fileName, String fileType) {
    final lower = fileName.toLowerCase();
    if (lower.contains('blood')) {
      return 'Blood Test';
    }
    if (lower.contains('xray') || lower.contains('x-ray')) {
      return 'X-Ray';
    }
    if (lower.contains('mri')) {
      return 'MRI';
    }
    if (lower.contains('ecg')) {
      return 'ECG';
    }
    return fileType == 'Image' ? 'Diagnostic Image' : 'General Medical Report';
  }

  List<String> _mockAbnormalFindings(String detectedType) {
    switch (detectedType) {
      case 'Blood Test':
        return <String>['Hemoglobin slightly low', 'CRP mildly elevated'];
      case 'X-Ray':
        return <String>['Mild opacity noted in lower lobe'];
      case 'ECG':
        return <String>['Minor rhythm irregularity observed'];
      default:
        return <String>[];
    }
  }

  String _mockSummary(String detectedType, List<String> abnormalFindings) {
    if (abnormalFindings.isEmpty) {
      return 'No major abnormal patterns were detected in this $detectedType report.';
    }
    return 'Potential abnormalities detected in this $detectedType report. Please consult a doctor for clinical interpretation.';
  }

  Future<List<ReportModel>> fetchReports() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return List<ReportModel>.from(_reports)
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
  }

  Future<ReportModel> uploadReport({
    required String fileName,
    required String fileType,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final detectedType = _detectReportType(fileName, fileType);
    final abnormalFindings = _mockAbnormalFindings(detectedType);
    final report = ReportModel(
      id: 'rp-${DateTime.now().millisecondsSinceEpoch}',
      fileName: fileName,
      fileType: fileType,
      detectedType: detectedType,
      aiSummary: _mockSummary(detectedType, abnormalFindings),
      abnormalFindings: abnormalFindings,
      confidence: abnormalFindings.isEmpty ? 'LOW' : 'MEDIUM',
      uploadedAt: DateTime.now(),
    );
    _reports.add(report);
    return report;
  }
}
