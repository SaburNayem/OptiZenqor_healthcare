import 'package:flutter/material.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/models/symptom_result_model.dart';

class EmergencyAlertScreen extends StatelessWidget {
  const EmergencyAlertScreen({
    super.key,
    required this.result,
  });

  final SymptomResultModel result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F1),
      appBar: AppBar(title: const Text('Emergency Alert')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.danger),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: AppColors.danger),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Possible Emergency Situation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please go to nearest hospital or call emergency services immediately.',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(result.disclaimer),
            const SizedBox(height: 8),
            Text('Suggested care: ${result.doctorType}'),
            const Spacer(),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Call your local emergency number now.'),
                  ),
                );
              },
              icon: const Icon(Icons.call),
              label: const Text('Call Emergency'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  RouteNames.doctors,
                  arguments: result.doctorType,
                );
              },
              icon: const Icon(Icons.local_hospital_outlined),
              label: const Text('Consult Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}
