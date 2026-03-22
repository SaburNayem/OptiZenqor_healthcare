import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loader.dart';
import '../appointment_controller/appointment_controller.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentControllerProvider);
    final controller = ref.read(appointmentControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(RouteNames.doctors),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: state.isLoading
          ? const AppLoader(message: 'Loading appointments...')
          : state.errorMessage != null
              ? AppErrorView(
                  message: state.errorMessage!,
                  onRetry: controller.loadAppointments,
                )
              : state.appointments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('No appointments yet'),
                          const SizedBox(height: 10),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pushNamed(RouteNames.doctors),
                            child: const Text('Find doctors'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: controller.loadAppointments,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.appointments.length,
                        itemBuilder: (context, index) {
                          final item = state.appointments[index];
                          final statusColor = switch (item.status) {
                            'upcoming' => AppColors.primary,
                            'ongoing' => AppColors.success,
                            'cancelled' => AppColors.danger,
                            _ => AppColors.textSecondary,
                          };
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.doctorName,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(item.specialization),
                                  const SizedBox(height: 6),
                                  Text(DateFormat('EEE, MMM d - hh:mm a').format(item.dateTime)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Text('Status: '),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor.withValues(alpha: 0.14),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          item.status.toUpperCase(),
                                          style: TextStyle(
                                            color: statusColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
