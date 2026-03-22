import '../../../core/services/local_storage_service.dart';
import '../domain/user_model.dart';

class AuthService {
  AuthService(this._storageService);

  final LocalStorageService _storageService;

  Future<UserModel> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!email.contains('@') || password.length < 6) {
      throw Exception('Invalid email or password');
    }

    final user = UserModel(
      name: email.split('@').first,
      email: email,
    );
    await _storageService.saveSession(email);
    return user;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (name.trim().isEmpty || !email.contains('@') || password.length < 6) {
      throw Exception('Please enter valid details');
    }
    final user = UserModel(name: name.trim(), email: email.trim());
    await _storageService.saveSession(email);
    return user;
  }

  Future<UserModel?> restoreSession() async {
    final email = await _storageService.getSessionEmail();
    if (email == null) {
      return null;
    }
    return UserModel(name: email.split('@').first, email: email);
  }

  Future<void> logout() async {
    await _storageService.clearSession();
  }
}
