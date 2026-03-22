import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../domain/models/symptom_result_model.dart';

class SymptomResultScreen extends StatelessWidget {
  const SymptomResultScreen({
    super.key,
    required this.result,
  });

  final SymptomResultModel result;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('MMM d, yyyy - hh:mm a').format(result.checkedAt);
    final urgencyColor = switch (result.urgency) {
      'CRITICAL' => AppColors.danger,
      'HIGH' => AppColors.warning,
      'MEDIUM' => AppColors.primary,
      _ => AppColors.success,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Assessment Result')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              result.disclaimer,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Urgency: '),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: urgencyColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        result.urgency,
                        style: TextStyle(
                          color: urgencyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Doctor type: ${result.doctorType}'),
                const SizedBox(height: 8),
                Text('Confidence: ${result.confidenceLevel}'),
                const SizedBox(height: 8),
                Text(result.patientSummary),
                const SizedBox(height: 8),
                Text('Checked on: $dateLabel'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Possible conditions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...result.possibleConditions.map((e) => Text('- $e')),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety actions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...result.safetyActions.map((action) => Text('- $action')),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Symptoms you selected',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(result.selectedSymptoms.join(', ')),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(
                RouteNames.doctors,
                arguments: result.doctorType,
              );
            },
            icon: const Icon(Icons.medical_services_outlined),
            label: const Text('Consult Doctor'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pushNamed(RouteNames.bookAppointment),
            child: const Text('Book Appointment Now'),
          ),
        ],
      ),
    );
  }
}
