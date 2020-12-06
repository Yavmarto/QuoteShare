import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quote_share/services/database.dart';
import 'package:quote_share/services/firebase_app_mock.dart';

/// Mock User Class
class MockUser extends Mock implements User {}


/// Mock User
final MockUser mockUser = MockUser();

class MockFirestore extends Mock implements FirebaseFirestore {

}

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  final MockFirestore mockFirestore = MockFirestore();
  final Database database = Database(firestore: mockFirestore);


  // /// Test: Check if Sign in Anonymously works
  // test("Download personal Quotes", () async {
  //   when(
  //     mockFirestore.collection("collectionPath").doc("user").get(),
  //   ).thenAnswer((realInvocation) => "Success");

  //   expect(await database.downloadPersonalQuotes(mockUser), "Success");
  // });
  
}