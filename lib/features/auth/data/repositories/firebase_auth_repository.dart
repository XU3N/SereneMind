import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  bool isUserSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Helper method to handle Firebase Auth errors and convert them to user-friendly messages
  Exception _handleFirebaseAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return Exception('No user found with this email.');
        case 'wrong-password':
          return Exception('Incorrect password.');
        case 'invalid-email':
          return Exception('The email address is not valid.');
        case 'user-disabled':
          return Exception('This user account has been disabled.');
        case 'too-many-requests':
          return Exception('Too many login attempts. Please try again later.');
        case 'operation-not-allowed':
          return Exception('Sign in with Email and Password is not enabled.');
        case 'network-request-failed':
          return Exception('Network error. Please check your connection.');
        case 'invalid-credential':
          return Exception('Invalid credentials. Please try again.');
        default:
          return Exception('An error occurred: ${error.message}');
      }
    }
    return Exception('An unexpected error occurred: $error');
  }
}
