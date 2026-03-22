import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../doctors/doctors_controller/doctors_controller.dart';
import '../data/appointment_service.dart';
import '../domain/appointment_model.dart';

final appointmentServiceProvider = Provider<AppointmentService>((ref) {
  return AppointmentService();
});

class AppointmentState {
  const AppointmentState({
    this.appointments = const [],
    this.availableSlots = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<AppointmentModel> appointments;
  final List<String> availableSlots;
  final bool isLoading;
  final String? errorMessage;

  AppointmentState copyWith({
    List<AppointmentModel>? appointments,
    List<String>? availableSlots,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppointmentState(
      appointments: appointments ?? this.appointments,
      availableSlots: availableSlots ?? this.availableSlots,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AppointmentController extends StateNotifier<AppointmentState> {
  AppointmentController(this._service) : super(const AppointmentState()) {
    loadAppointments();
  }

  final AppointmentService _service;

  Future<void> loadAppointments() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final appointments = await _service.fetchAppointments();
      state = state.copyWith(appointments: appointments, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not load appointments',
      );
    }
  }

  Future<bool> bookAppointment({
    required String doctorId,
    required String doctorName,
    required String specialization,
    required DateTime dateTime,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _service.bookAppointment(
        doctorId: doctorId,
        doctorName: doctorName,
        specialization: specialization,
        dateTime: dateTime,
      );
      final appointments = await _service.fetchAppointments();
      state = state.copyWith(appointments: appointments, isLoading: false);
      return true;
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Booking failed');
      return false;
    }
  }

  Future<void> loadAvailableSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final slots = await _service.fetchAvailableSlots(doctorId: doctorId, date: date);
      state = state.copyWith(availableSlots: slots, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Could not fetch slots');
    }
  }
}

final appointmentControllerProvider =
    StateNotifierProvider<AppointmentController, AppointmentState>((ref) {
  return AppointmentController(ref.watch(appointmentServiceProvider));
});

final availableDoctorsProvider = Provider<List<String>>((ref) {
  final doctors = ref.watch(doctorsControllerProvider).doctors;
  return doctors.map((d) => '${d.id}|${d.name}|${d.specialization}').toList(growable: false);
});
