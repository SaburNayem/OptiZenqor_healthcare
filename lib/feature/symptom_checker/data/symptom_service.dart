import '../domain/models/symptom_assessment_input_model.dart';
import '../domain/models/symptom_result_model.dart';

class SymptomService {
  Future<SymptomResultModel> analyzeSymptoms(SymptomAssessmentInputModel input) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    final lowered = input.selectedSymptoms.map((e) => e.toLowerCase()).toList();
    final hasEmergencySymptom =
        lowered.contains('chest pain') || lowered.contains('shortness of breath');
    final severeAndAcute = input.severity >= 8 && input.durationDays <= 2;
    final hasDangerSignal =
        input.followUpAnswers['fainting'] == true ||
        input.followUpAnswers['confusion'] == true ||
        input.followUpAnswers['bloodInCough'] == true;

    final isEmergency = hasEmergencySymptom && (severeAndAcute || hasDangerSignal);

    String doctorType = 'General Physician';
    String urgency = 'LOW';
    String confidenceLevel = 'LOW';
    List<String> possibleConditions = <String>['Could be a mild viral illness'];
    final safetyActions = <String>[
      'Rest, hydrate, and monitor symptoms closely.',
      'If symptoms worsen, consult a doctor promptly.',
      'This is not a medical diagnosis.',
    ];

    if (isEmergency) {
      doctorType = 'Emergency Physician';
      urgency = 'CRITICAL';
      confidenceLevel = 'MEDIUM';
      possibleConditions = <String>[
        'Could be a serious heart or lung condition',
        'Could be an acute respiratory emergency',
      ];
      safetyActions
        ..clear()
        ..addAll(<String>[
          'Please go to the nearest hospital immediately.',
          'Call emergency services now if available in your region.',
          'Do not drive yourself if you feel dizzy or breathless.',
          'This is not a medical diagnosis.',
        ]);
    } else if (lowered.contains('chest pain') || lowered.contains('shortness of breath')) {
      doctorType = 'Cardiologist';
      urgency = 'HIGH';
      confidenceLevel = 'LOW';
      possibleConditions = <String>[
        'Could be a cardiovascular issue',
        'Could be a respiratory condition',
      ];
      safetyActions
        ..clear()
        ..addAll(<String>[
          'Seek urgent care today.',
          'Avoid heavy activity until reviewed by a doctor.',
          'If pain or breathing worsens, go to emergency immediately.',
          'This is not a medical diagnosis.',
        ]);
    } else if (lowered.contains('headache') && lowered.contains('nausea')) {
      doctorType = 'Neurologist';
      urgency = input.severity >= 7 ? 'HIGH' : 'MEDIUM';
      confidenceLevel = 'MEDIUM';
      possibleConditions = <String>[
        'Could be migraine',
        'Could be tension-type headache',
      ];
      safetyActions
        ..clear()
        ..addAll(<String>[
          'Book a doctor visit within 24-48 hours.',
          'Maintain hydration and avoid bright screens.',
          'Go to urgent care if severe or persistent.',
          'This is not a medical diagnosis.',
        ]);
    } else if (lowered.contains('fever') && lowered.contains('cough')) {
      doctorType = 'Pulmonologist';
      urgency = input.severity >= 7 ? 'HIGH' : 'MEDIUM';
      confidenceLevel = 'MEDIUM';
      possibleConditions = <String>[
        'Could be influenza',
        'Could be upper respiratory infection',
      ];
      safetyActions
        ..clear()
        ..addAll(<String>[
          'Arrange a doctor review soon.',
          'Use fever monitoring and hydration.',
          'Seek urgent care for breathing difficulty.',
          'This is not a medical diagnosis.',
        ]);
    }

    return SymptomResultModel(
      selectedSymptoms: input.selectedSymptoms,
      possibleConditions: possibleConditions,
      doctorType: doctorType,
      urgency: urgency,
      confidenceLevel: confidenceLevel,
      disclaimer: 'This is not a medical diagnosis. Please consult a licensed doctor.',
      safetyActions: safetyActions,
      isEmergency: isEmergency,
      patientSummary:
          'Age ${input.age}, ${input.gender}, duration ${input.durationDays} day(s), severity ${input.severity}/10',
      checkedAt: DateTime.now(),
    );
  }
}
