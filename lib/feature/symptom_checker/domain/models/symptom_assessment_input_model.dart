class SymptomAssessmentInputModel {
  const SymptomAssessmentInputModel({
    required this.age,
    required this.gender,
    required this.durationDays,
    required this.severity,
    required this.selectedSymptoms,
    required this.followUpAnswers,
  });

  final int age;
  final String gender;
  final int durationDays;
  final int severity;
  final List<String> selectedSymptoms;
  final Map<String, bool> followUpAnswers;
}
