import 'dart:async';

import '../../models/user.dart';

class MockAuthRepository {
  final Map<String, String> _emailToPassword = {};
  final Map<String, UserModel> _emailToUser = {};

  Future<UserModel> register({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_emailToUser.containsKey(email)) {
      throw Exception('Email already registered');
    }
    final user = UserModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, email: email);
    _emailToUser[email] = user;
    _emailToPassword[email] = password;
    return user;
  }

  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!_emailToPassword.containsKey(email) || _emailToPassword[email] != password) {
      throw Exception('Invalid credentials');
    }
    return _emailToUser[email]!;
  }
}


