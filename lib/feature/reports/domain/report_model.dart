class ReportModel {
  const ReportModel({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.detectedType,
    required this.aiSummary,
    required this.abnormalFindings,
    required this.confidence,
    required this.uploadedAt,
  });

  final String id;
  final String fileName;
  final String fileType;
  final String detectedType;
  final String aiSummary;
  final List<String> abnormalFindings;
  final String confidence;
  final DateTime uploadedAt;
}
