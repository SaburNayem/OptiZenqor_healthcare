import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _sessionKey = 'user_session_email';

  Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, email);
  }

  Future<String?> getSessionEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
