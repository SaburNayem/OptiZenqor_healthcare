import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../symptom_checker_controller/symptom_checker_controller.dart';

class SymptomCheckerScreen extends ConsumerStatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  ConsumerState<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends ConsumerState<SymptomCheckerScreen> {
  final _ageController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(symptomCheckerControllerProvider);
    final controller = ref.read(symptomCheckerControllerProvider.notifier);
    final progress = (state.currentStep + 1) / 4;

    if (state.age != null && _ageController.text.isEmpty) {
      _ageController.text = '${state.age}';
    }
    if (state.durationDays != null && _durationController.text.isEmpty) {
      _durationController.text = '${state.durationDays}';
    }

    final questionLabels = <String, String>{
      'fainting': 'Have you fainted recently?',
      'confusion': 'Are you feeling confused or disoriented?',
      'bloodInCough': 'Have you noticed blood while coughing?',
    };

    final steps = <Step>[
      Step(
        title: const Text('Patient Details'),
        content: Column(
          children: [
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
              onChanged: (value) => controller.updateAge(int.tryParse(value)),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: state.gender,
              decoration: const InputDecoration(labelText: 'Gender'),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Non-binary', child: Text('Non-binary')),
                DropdownMenuItem(
                  value: 'Prefer not to say',
                  child: Text('Prefer not to say'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.updateGender(value);
                }
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration in days'),
              onChanged: (value) => controller.updateDurationDays(int.tryParse(value)),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Symptom severity: ${state.severity}/10'),
            ),
            Slider(
              min: 1,
              max: 10,
              divisions: 9,
              value: state.severity.toDouble(),
              onChanged: (value) => controller.updateSeverity(value.round()),
            ),
          ],
        ),
      ),
      Step(
        title: const Text('Symptoms'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: symptomCatalog
              .map(
                (item) => FilterChip(
                  label: Text(item),
                  selected: state.selectedSymptoms.contains(item),
                  onSelected: (_) => controller.toggleSymptom(item),
                ),
              )
              .toList(),
        ),
      ),
      Step(
        title: const Text('Safety Questions'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.dynamicQuestions.isEmpty)
              const Text('No additional risk questions for your selected symptoms.'),
            ...state.dynamicQuestions.map(
              (questionKey) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(questionLabels[questionKey] ?? questionKey),
                    const SizedBox(height: 6),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment<bool>(value: true, label: Text('Yes')),
                        ButtonSegment<bool>(value: false, label: Text('No')),
                      ],
                      selected: {
                        state.followUpAnswers[questionKey] ?? false,
                      },
                      onSelectionChanged: (selection) {
                        controller.answerFollowUp(questionKey, selection.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Step(
        title: const Text('Analyze'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review and analyze. This is a screening aid only, not a medical diagnosis.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Selected: ${state.selectedSymptoms.join(', ')}',
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Analyze symptoms safely',
              isLoading: state.isLoading,
              onPressed: () async {
                final result = await controller.runCheck();
                if (!context.mounted || result == null) {
                  return;
                }
                if (result.isEmergency) {
                  Navigator.of(context).pushNamed(
                    RouteNames.emergencyAlert,
                    arguments: result,
                  );
                  return;
                }
                Navigator.of(context).pushNamed(
                  RouteNames.symptomResult,
                  arguments: result,
                );
              },
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Symptom Checker')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 6),
                Text('Step ${state.currentStep + 1} of 4'),
              ],
            ),
          ),
          if (state.errorMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(state.errorMessage!),
            ),
          Expanded(
            child: Stepper(
              currentStep: state.currentStep,
              onStepContinue: controller.nextStep,
              onStepCancel: controller.previousStep,
              controlsBuilder: (context, details) {
                if (state.currentStep == 3) {
                  return const SizedBox.shrink();
                }
                return Row(
                  children: [
                    FilledButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Next'),
                    ),
                    const SizedBox(width: 8),
                    if (state.currentStep > 0)
                      OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Back'),
                      ),
                  ],
                );
              },
              steps: steps,
            ),
          ),
        ],
      ),
    );
  }
}
