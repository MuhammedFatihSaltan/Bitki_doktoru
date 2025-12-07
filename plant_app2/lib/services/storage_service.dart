import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';

  // Beni hatırla durumunu kaydet
  Future<void> setRememberMe(bool value, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
    if (value) {
      await prefs.setString(_savedEmailKey, email);
    } else {
      await prefs.remove(_savedEmailKey);
    }
  }

  // Beni hatırla durumunu kontrol et
  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  // Kaydedilmiş emaili al
  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedEmailKey);
  }

  // Tüm verileri temizle
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
