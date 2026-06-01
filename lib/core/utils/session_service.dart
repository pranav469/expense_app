import 'package:expense_manager/features/auth/presentation/pages/login_page.dart';
import 'package:expense_manager/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static Future<String> getNickname() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('nickname') ?? '';
  }

  static Future<void> setNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('nickname', nickname);
  }

  static Future<void> setLimit(double limit) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('limit', limit);
  }

  static Future<double> getLimit() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getDouble('limit') ?? 0.0;
  }

  static Future<String> getPhone() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('phone') ?? '';
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token') ?? '';
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }
}
