import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quote_share/auth.dart';
import 'package:quote_share/firebase_app_mock.dart';

/// Mock User Class
class MockUser extends Mock implements User {}

/// Mock User
final MockUser mockUser = MockUser();

/// Mock Firebase Authentication Class
class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      mockUser,
    ]);
  }
}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth = Auth(auth: mockFirebaseAuth);

  /// Test: check if emit occurs
  test("emit occurs", () async {
    expectLater(auth.user, emitsInOrder([mockUser]));
  });

  /// Test: Check if Sign in Anonymously works
  test("Sign in Anonymously", () async {
    when(
      mockFirebaseAuth.signInAnonymously(),
    ).thenAnswer((realInvocation) => null);

    expect(await auth.signInAnonymously(), "Success");
  });

  /// Test: Check if Sign in Anonymously Exception works
  test("Sign in Anonymouslyexception", () async {
    when(
      auth.signInAnonymously(),
    ).thenAnswer((realInvocation) =>
        throw FirebaseAuthException(message: "Firebase Error"));

    expect(await auth.signInAnonymously(), "Firebase Error");
  });
}
