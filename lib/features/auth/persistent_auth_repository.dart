import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

class PersistentAuthRepository {
  static const String _userKey = 'logged_in_user';
  static const String _emailToPasswordKey = 'email_password_map';
  static const String _emailToUserKey = 'email_user_map';

  // Save user data to persistent storage
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode({
      'id': user.id,
      'name': user.name,
      'email': user.email,
    }));
  }

  // Get saved user data
  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel(
          id: userMap['id'] as String,
          name: userMap['name'] as String,
          email: userMap['email'] as String,
        );
      } catch (e) {
        // If parsing fails, remove the corrupted data
        await prefs.remove(_userKey);
      }
    }
    return null;
  }

  // Clear saved user data
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Save email to password mapping (for demo purposes - in real app, passwords should be hashed)
  Future<void> saveEmailPassword(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getEmailPasswordMap();
    existing[email] = password;
    await prefs.setString(_emailToPasswordKey, jsonEncode(existing));
  }

  // Get email to password mapping
  Future<Map<String, String>> getEmailPasswordMap() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_emailToPasswordKey);
    if (json != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(json);
        return decoded.map((key, value) => MapEntry(key, value.toString()));
      } catch (e) {
        return {};
      }
    }
    return {};
  }

  // Save email to user mapping
  Future<void> saveEmailUser(String email, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getEmailUserMap();
    existing[email] = user;
    await prefs.setString(_emailToUserKey, jsonEncode(existing.map(
      (key, user) => MapEntry(key, {
        'id': user.id,
        'name': user.name,
        'email': user.email,
      })
    )));
  }

  // Get email to user mapping
  Future<Map<String, UserModel>> getEmailUserMap() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_emailToUserKey);
    if (json != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(json);
        return decoded.map((key, userMap) => MapEntry(
          key,
          UserModel(
            id: userMap['id'] as String,
            name: userMap['name'] as String,
            email: userMap['email'] as String,
          ),
        ));
      } catch (e) {
        return {};
      }
    }
    return {};
  }

  // Clear all auth data
  Future<void> clearAllAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_emailToPasswordKey);
    await prefs.remove(_emailToUserKey);
  }
}
