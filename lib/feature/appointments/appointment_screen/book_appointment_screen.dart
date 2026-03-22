import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/widgets/primary_button.dart';
import '../../doctors/domain/doctor_model.dart';
import '../appointment_controller/appointment_controller.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  ConsumerState<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  DateTime? _selectedDate;
  String? _selectedSlot;
  String? _selectedDoctor;

  Future<void> _selectDate(WidgetRef ref, String doctorId) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date == null || !context.mounted) {
      return;
    }
    setState(() {
      _selectedDate = date;
      _selectedSlot = null;
    });
    await ref
        .read(appointmentControllerProvider.notifier)
        .loadAvailableSlots(doctorId: doctorId, date: date);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentControllerProvider);
    final controller = ref.read(appointmentControllerProvider.notifier);
    final doctorArg = ModalRoute.of(context)?.settings.arguments;
    final availableDoctors = ref.watch(availableDoctorsProvider);

    if (_selectedDoctor == null && doctorArg is DoctorModel) {
      _selectedDoctor = '${doctorArg.id}|${doctorArg.name}|${doctorArg.specialization}';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedDoctor,
            decoration: const InputDecoration(labelText: 'Select doctor'),
            items: availableDoctors
                .map((e) {
                  final parts = e.split('|');
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text('${parts[1]} (${parts[2]})'),
                  );
                })
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedDoctor = value;
                _selectedDate = null;
                _selectedSlot = null;
              });
            },
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _selectedDoctor == null
                ? null
                : () {
                    final doctorId = _selectedDoctor!.split('|')[0];
                    _selectDate(ref, doctorId);
                  },
            icon: const Icon(Icons.schedule),
            label: Text(
              _selectedDate == null
                  ? 'Choose date'
                  : DateFormat('EEE, MMM d').format(_selectedDate!),
            ),
          ),
          if (_selectedDate != null) ...[
            const SizedBox(height: 14),
            Text(
              'Available slots',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (state.availableSlots.isEmpty)
              const Text('No slots available for this date. Please choose another date.'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.availableSlots
                  .map(
                    (slot) => ChoiceChip(
                      label: Text(slot),
                      selected: _selectedSlot == slot,
                      onSelected: (_) => setState(() => _selectedSlot = slot),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Confirm Booking',
            isLoading: state.isLoading,
            onPressed: () async {
              if (_selectedDoctor == null || _selectedDate == null || _selectedSlot == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Select doctor, date, and an available slot')),
                );
                return;
              }

              final parts = _selectedDoctor!.split('|');
              final doctorId = parts[0];
              final doctorName = parts[1];
              final specialization = parts[2];
              final slotParts = _selectedSlot!.split(':');
              final dateTime = DateTime(
                _selectedDate!.year,
                _selectedDate!.month,
                _selectedDate!.day,
                int.parse(slotParts[0]),
                int.parse(slotParts[1]),
              );

              final ok = await controller.bookAppointment(
                doctorId: doctorId,
                doctorName: doctorName,
                specialization: specialization,
                dateTime: dateTime,
              );
              if (!context.mounted) {
                return;
              }
              if (ok) {
                Navigator.of(context).pushReplacementNamed(RouteNames.bookingSuccess);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ref.read(appointmentControllerProvider).errorMessage ?? 'Booking failed',
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
