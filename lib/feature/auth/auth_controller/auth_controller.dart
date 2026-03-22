import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/local_storage_service.dart';
import '../data/auth_service.dart';
import '../domain/user_model.dart';

final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(localStorageProvider));
});

class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  bool get isLoggedIn => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._service) : super(const AuthState());

  final AuthService _service;

  Future<void> restoreSession() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _service.restoreSession();
      state = state.copyWith(user: user, isLoading: false, clearError: true);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not restore session',
      );
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _service.login(email: email, password: password);
      state = state.copyWith(user: user, isLoading: false, clearError: true);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _service.register(
        name: name,
        email: email,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false, clearError: true);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    state = const AuthState();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authServiceProvider));
});
