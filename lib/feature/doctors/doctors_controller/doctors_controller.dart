import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/doctor_service.dart';
import '../domain/doctor_model.dart';

final doctorServiceProvider = Provider<DoctorService>((ref) {
  return DoctorService();
});

class DoctorsState {
  const DoctorsState({
    this.doctors = const [],
    this.filter = 'All',
    this.isLoading = false,
    this.errorMessage,
  });

  final List<DoctorModel> doctors;
  final String filter;
  final bool isLoading;
  final String? errorMessage;

  List<DoctorModel> get filteredDoctors {
    if (filter == 'All') {
      return doctors;
    }
    return doctors.where((d) => d.specialization == filter).toList();
  }

  List<String> get specializations {
    final list = doctors.map((d) => d.specialization).toSet().toList()..sort();
    return ['All', ...list];
  }

  DoctorsState copyWith({
    List<DoctorModel>? doctors,
    String? filter,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoctorsState(
      doctors: doctors ?? this.doctors,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class DoctorsController extends StateNotifier<DoctorsState> {
  DoctorsController(this._service) : super(const DoctorsState()) {
    loadDoctors();
  }

  final DoctorService _service;

  Future<void> loadDoctors() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final doctors = await _service.fetchDoctors();
      state = state.copyWith(doctors: doctors, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Could not load doctors');
    }
  }

  void setFilter(String value) {
    state = state.copyWith(filter: value);
  }
}

final doctorsControllerProvider =
    StateNotifierProvider<DoctorsController, DoctorsState>((ref) {
  return DoctorsController(ref.watch(doctorServiceProvider));
});
