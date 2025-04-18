import 'package:firebase_auth/firebase_auth.dart';
import '../domain/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  /// Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _authRepository.signInWithEmailAndPassword(
        email,
        password,
      );
      return userCredential.user;
    } on Exception catch (e) {
      // Re-throw the exception for the UI to handle
      throw e;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  /// Get the current user
  User? getCurrentUser() {
    return _authRepository.getCurrentUser();
  }

  /// Check if the user is signed in
  bool isUserSignedIn() {
    return _authRepository.isUserSignedIn();
  }

  /// Get auth state changes stream
  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  /// Validate email address format
  bool isEmailValid(String email) {
    // Simple email validation regex
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate password (add your requirements as needed)
  bool isPasswordValid(String password) {
    // Simple check for minimum length
    return password.length >= 6;
  }
}
