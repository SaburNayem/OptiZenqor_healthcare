import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loader.dart';
import '../doctors_controller/doctors_controller.dart';

class DoctorsScreen extends ConsumerWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorsControllerProvider);
    final controller = ref.read(doctorsControllerProvider.notifier);
    final suggestedSpecialization =
        ModalRoute.of(context)?.settings.arguments as String?;

    final recommended = state.doctors
        .where((d) =>
            suggestedSpecialization == null ||
            d.specialization == suggestedSpecialization)
        .toList()
      ..sort((a, b) {
        final availabilityCompare = (b.isAvailableNow ? 1 : 0) - (a.isAvailableNow ? 1 : 0);
        if (availabilityCompare != 0) {
          return availabilityCompare;
        }
        return b.rating.compareTo(a.rating);
      });

    return Scaffold(
      appBar: AppBar(title: const Text('Doctors')),
      body: state.isLoading
          ? const AppLoader(message: 'Loading doctors...')
          : state.errorMessage != null
              ? AppErrorView(
                  message: state.errorMessage!,
                  onRetry: controller.loadDoctors,
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (suggestedSpecialization != null && recommended.isNotEmpty)
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Smart Recommendation',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${recommended.first.name} (${recommended.first.specialization})',
                            ),
                            Text(
                              'Rating ${recommended.first.rating.toStringAsFixed(1)} | ${recommended.first.experienceYears} years exp',
                            ),
                            Text(
                              recommended.first.isAvailableNow
                                  ? 'Available now'
                                  : 'Next available: ${recommended.first.nextAvailable}',
                            ),
                          ],
                        ),
                      ),
                    if (suggestedSpecialization != null && recommended.isNotEmpty)
                      const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.specializations
                          .map(
                            (spec) => ChoiceChip(
                              label: Text(spec),
                              selected: state.filter == spec,
                              onSelected: (_) => controller.setFilter(spec),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    ...state.filteredDoctors.map(
                      (doctor) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppCard(
                          child: Row(
                            children: [
                              const CircleAvatar(child: Icon(Icons.person_outline)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor.name,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    Text(doctor.specialization),
                                    Text('Rating: ${doctor.rating.toStringAsFixed(1)}'),
                                    Text('Experience: ${doctor.experienceYears} years'),
                                    Text(
                                      doctor.isAvailableNow
                                          ? 'Available now'
                                          : 'Next: ${doctor.nextAvailable}',
                                    ),
                                  ],
                                ),
                              ),
                              FilledButton.tonal(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    RouteNames.bookAppointment,
                                    arguments: doctor,
                                  );
                                },
                                child: const Text('Book'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
