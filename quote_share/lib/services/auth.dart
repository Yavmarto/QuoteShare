import 'package:firebase_auth/firebase_auth.dart';

/// Implements Authentication class
class Auth {
  Auth({this.auth});

  /// Firebase authentication
  final FirebaseAuth auth;

  /// User stream
  Stream<User> get user => auth.authStateChanges();

  /// Firebase sign in Anonymously
  Future<String> signInAnonymously() async {
    try {
      await auth.signInAnonymously();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }
}