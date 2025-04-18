import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password);

  /// Sign out the current user
  Future<void> signOut();

  /// Get the current user
  User? getCurrentUser();

  /// Check if the user is signed in
  bool isUserSignedIn();

  /// Listen to auth state changes
  Stream<User?> get authStateChanges;
}
