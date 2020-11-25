import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quote_share/quote.dart';

class FirebaseConnection {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference quotes = FirebaseFirestore.instance.collection('quotes');

  User localUser;
  UserCredential credential;


  void signIn() async {
    credential = await auth.signInAnonymously();
  }

  Future<void> addRating(Quote quote, int rating) {

    return quotes
    .add({
      'id' : quote.id,
      'author' : quote.author,
      'content': quote.content,
      'rating' : rating
    })
    .then((value) => print("Quote added")).catchError((error) => print("Failed to add Quote"));
  
  }

}
