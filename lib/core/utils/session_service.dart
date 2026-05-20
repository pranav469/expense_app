import 'package:shared_preferences/shared_preferences.dart';

class SessionService {

  static Future<String> getNickname() async {
    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString('nickname') ?? '';
  }

  static Future<String> getPhone() async {
    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString('phone') ?? '';
  }

  static Future<String> getToken() async {
    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString('token') ?? '';
  }

  static Future<void> logout() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.clear();
  }
}