import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/widgets/app_card.dart';
import '../../appointments/appointment_controller/appointment_controller.dart';
import '../../auth/auth_controller/auth_controller.dart';
import '../../auth/auth_screen/login_screen.dart';
import '../../reports/report_controller/report_controller.dart';
import '../../symptom_checker/symptom_checker_controller/symptom_checker_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final appointments = ref.watch(appointmentControllerProvider).appointments;
    final reports = ref.watch(reportControllerProvider).reports;
    final symptomHistory = ref.watch(symptomCheckerControllerProvider).history;

    final lastAppointment = appointments.isEmpty ? null : appointments.first;
    final recentSymptoms = symptomHistory.isEmpty
        ? 'No recent symptom checks yet.'
        : symptomHistory.first.selectedSymptoms.join(', ');
    final abnormalReports = reports.where((r) => r.abnormalFindings.isNotEmpty).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Row(
              children: [
                const CircleAvatar(radius: 28, child: Icon(Icons.person_outline)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? 'Guest', style: Theme.of(context).textTheme.titleMedium),
                    Text(user?.email ?? 'No email'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Health Summary', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Recent symptoms: $recentSymptoms'),
                const SizedBox(height: 6),
                Text(
                  lastAppointment == null
                      ? 'Last appointment: none'
                      : 'Last appointment: ${lastAppointment.doctorName} on ${DateFormat('MMM d, yyyy').format(lastAppointment.dateTime)}',
                ),
                const SizedBox(height: 6),
                Text(
                  'Reports: ${reports.length} total, $abnormalReports with abnormal markers',
                ),
                const SizedBox(height: 8),
                const Text(
                  'This summary is for tracking only and not a medical diagnosis.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            onTap: () => Navigator.of(context).pushNamed(RouteNames.history),
            child: const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.history),
              title: Text('History'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            onTap: () => Navigator.of(context).pushNamed(RouteNames.notifications),
            child: const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.notifications_outlined),
              title: Text('Notifications'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (!context.mounted) {
                return;
              }
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
