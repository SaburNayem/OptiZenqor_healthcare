class SymptomResultModel {
  const SymptomResultModel({
    required this.selectedSymptoms,
    required this.possibleConditions,
    required this.doctorType,
    required this.urgency,
    required this.confidenceLevel,
    required this.disclaimer,
    required this.safetyActions,
    required this.isEmergency,
    required this.patientSummary,
    required this.checkedAt,
  });

  final List<String> selectedSymptoms;
  final List<String> possibleConditions;
  final String doctorType;
  final String urgency;
  final String confidenceLevel;
  final String disclaimer;
  final List<String> safetyActions;
  final bool isEmergency;
  final String patientSummary;
  final DateTime checkedAt;
}
