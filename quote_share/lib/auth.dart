import 'package:firebase_auth/firebase_auth.dart';

/// Authentication class
class Auth {

  /// Firebase authentication
  final FirebaseAuth auth;

  /// Firebase constructor
  Auth({this.auth});

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