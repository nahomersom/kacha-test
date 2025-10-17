import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user.dart';
import '../persistent_auth_repository.dart';
import '../../../utils/validators.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._persistentRepo) : super(const AuthState()) {
    _loadSavedUser();
  }

  final PersistentAuthRepository _persistentRepo;

  // Load saved user on initialization
  Future<void> _loadSavedUser() async {
    final savedUser = await _persistentRepo.getSavedUser();
    if (savedUser != null) {
      state = AuthState(user: savedUser, isLoading: false, error: null);
    }
  }

  Future<void> register({required String name, required String email, required String password}) async {
    if (!AuthValidators.isValidEmail(email)) {
      state = state.copyWith(error: 'Invalid email format');
      return;
    }
    // Password validation removed - let UI strength indicator handle it
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Check if user already exists using persistent storage
      final existingUsers = await _persistentRepo.getEmailUserMap();
      if (existingUsers.containsKey(email)) {
        state = state.copyWith(error: 'Email already registered', isLoading: false);
        return;
      }
      
      // Create new user
      final user = UserModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, email: email);
      
      // Save user data persistently
      await _persistentRepo.saveUser(user);
      await _persistentRepo.saveEmailPassword(email, password);
      await _persistentRepo.saveEmailUser(email, user);
      
      state = AuthState(user: user, isLoading: false, error: null);
      print('Registration successful: ${user.name}');
      // Force a rebuild by adding a small delay
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> login({required String email, required String password}) async {
    if (!AuthValidators.isValidEmail(email)) {
      state = state.copyWith(error: 'Invalid email format');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Check credentials using persistent storage
      final emailPasswordMap = await _persistentRepo.getEmailPasswordMap();
      final emailUserMap = await _persistentRepo.getEmailUserMap();
      
      if (!emailPasswordMap.containsKey(email) || emailPasswordMap[email] != password) {
        state = state.copyWith(error: 'Invalid credentials', isLoading: false);
        return;
      }
      
      final user = emailUserMap[email];
      if (user == null) {
        state = state.copyWith(error: 'User not found', isLoading: false);
        return;
      }
      
      // Save user data persistently
      await _persistentRepo.saveUser(user);
      state = AuthState(user: user, isLoading: false, error: null);
      print('Login successful: ${user.name}');
      // Force a rebuild by adding a small delay
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> logout() async {
    await _persistentRepo.clearUser();
    state = const AuthState();
  }
}

final persistentAuthRepositoryProvider = Provider<PersistentAuthRepository>((ref) => PersistentAuthRepository());

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final persistentRepo = ref.read(persistentAuthRepositoryProvider);
  return AuthController(persistentRepo);
});


