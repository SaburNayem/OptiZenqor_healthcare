import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/symptom_service.dart';
import '../domain/models/symptom_assessment_input_model.dart';
import '../domain/models/symptom_result_model.dart';

const symptomCatalog = <String>[
  'Fever',
  'Headache',
  'Nausea',
  'Chest Pain',
  'Shortness of breath',
  'Fatigue',
  'Cough',
  'Sore throat',
  'Body ache',
  'Dizziness',
];

class SymptomCheckerState {
  const SymptomCheckerState({
    this.currentStep = 0,
    this.age,
    this.gender = 'Prefer not to say',
    this.durationDays,
    this.severity = 3,
    this.selectedSymptoms = const <String>{},
    this.followUpAnswers = const <String, bool>{},
    this.latestResult,
    this.history = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final int currentStep;
  final int? age;
  final String gender;
  final int? durationDays;
  final int severity;
  final Set<String> selectedSymptoms;
  final Map<String, bool> followUpAnswers;
  final SymptomResultModel? latestResult;
  final List<SymptomResultModel> history;
  final bool isLoading;
  final String? errorMessage;

  List<String> get dynamicQuestions {
    final lowered = selectedSymptoms.map((e) => e.toLowerCase()).toSet();
    final questions = <String>[];

    if (lowered.contains('chest pain') || lowered.contains('shortness of breath')) {
      questions.add('fainting');
      questions.add('confusion');
    }
    if (lowered.contains('cough')) {
      questions.add('bloodInCough');
    }
    return questions;
  }

  SymptomCheckerState copyWith({
    int? currentStep,
    int? age,
    String? gender,
    int? durationDays,
    int? severity,
    Set<String>? selectedSymptoms,
    Map<String, bool>? followUpAnswers,
    SymptomResultModel? latestResult,
    List<SymptomResultModel>? history,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SymptomCheckerState(
      currentStep: currentStep ?? this.currentStep,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      durationDays: durationDays ?? this.durationDays,
      severity: severity ?? this.severity,
      selectedSymptoms: selectedSymptoms ?? this.selectedSymptoms,
      followUpAnswers: followUpAnswers ?? this.followUpAnswers,
      latestResult: latestResult ?? this.latestResult,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class SymptomCheckerController extends StateNotifier<SymptomCheckerState> {
  SymptomCheckerController(this._service) : super(const SymptomCheckerState());

  final SymptomService _service;

  void toggleSymptom(String symptom) {
    final updated = Set<String>.from(state.selectedSymptoms);
    if (updated.contains(symptom)) {
      updated.remove(symptom);
    } else {
      updated.add(symptom);
    }
    state = state.copyWith(selectedSymptoms: updated, clearError: true);
  }

  void updateAge(int? age) {
    state = state.copyWith(age: age, clearError: true);
  }

  void updateGender(String value) {
    state = state.copyWith(gender: value, clearError: true);
  }

  void updateDurationDays(int? days) {
    state = state.copyWith(durationDays: days, clearError: true);
  }

  void updateSeverity(int value) {
    state = state.copyWith(severity: value, clearError: true);
  }

  void answerFollowUp(String questionKey, bool value) {
    final answers = Map<String, bool>.from(state.followUpAnswers)
      ..[questionKey] = value;
    state = state.copyWith(followUpAnswers: answers, clearError: true);
  }

  void nextStep() {
    if (state.currentStep == 0 && (state.age == null || state.durationDays == null)) {
      state = state.copyWith(errorMessage: 'Please provide age and symptom duration');
      return;
    }
    if (state.currentStep == 1 && state.selectedSymptoms.isEmpty) {
      state = state.copyWith(errorMessage: 'Please select at least one symptom');
      return;
    }
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<SymptomResultModel?> runCheck() async {
    if (state.age == null || state.durationDays == null || state.selectedSymptoms.isEmpty) {
      state = state.copyWith(errorMessage: 'Please complete all required symptom details');
      return null;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _service.analyzeSymptoms(
        SymptomAssessmentInputModel(
          age: state.age!,
          gender: state.gender,
          durationDays: state.durationDays!,
          severity: state.severity,
          selectedSymptoms: state.selectedSymptoms.toList(),
          followUpAnswers: state.followUpAnswers,
        ),
      );
      state = state.copyWith(
        isLoading: false,
        latestResult: result,
        history: [result, ...state.history],
      );
      return result;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to process symptoms now',
      );
      return null;
    }
  }

  void resetFlow() {
    state = const SymptomCheckerState();
  }
}

final symptomServiceProvider = Provider<SymptomService>((ref) {
  return SymptomService();
});

final symptomCheckerControllerProvider =
    StateNotifierProvider<SymptomCheckerController, SymptomCheckerState>((ref) {
  return SymptomCheckerController(ref.watch(symptomServiceProvider));
});
