import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quote_share/quote.dart';
import 'package:quote_share/quote_card.dart';

class FirebaseConnection {
  static final FirebaseConnection _instance = FirebaseConnection._internal();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference quotes = FirebaseFirestore.instance.collection('quotes');

  factory FirebaseConnection() {
    return _instance;
  }

  FirebaseConnection._internal();
  User localUser;
  UserCredential credential;

  // Sign in Anonymously
  void signIn() async {
    credential = await auth.signInAnonymously();
  }

  // Save new quote with rating to database
  Future<void> uploadRating(Quote quote, int rating) {
    String quoteID = quote.id.toString();

    return quotes
        .doc(localUser.uid)
        .update({
          quoteID: {
            'id': quote.id,
            'author': quote.author,
            'content': quote.content,
            'rating': rating
          }
        })
        .then((value) => print("Quote added"))
        .catchError((error) => print("Failed to add Quote"));
  }

  // Download Personal Quotes from database
  FutureBuilder<DocumentSnapshot> downloadPersonalQuotes() {
    return FutureBuilder<DocumentSnapshot>(
      future: quotes.doc(localUser.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData) {
            List<QuoteCard> cards = [];

        snapshot.data.data().forEach((key, value) { 
          cards.add(new QuoteCard(value["content"], value["author"]));
        });
        return ListView(
          padding: EdgeInsets.all(8),
          children: cards
        );

        }

        return Text("loading");
      },
    );
  }

}
