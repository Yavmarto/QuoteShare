import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quote_share/quote.dart';
import 'package:quote_share/quote_card.dart';

/// Database class
class Database {
  
  /// Firestore
  final FirebaseFirestore firestore;

  /// Firestore constructor
  Database({this.firestore});

  /// Save new quote with rating to database
  Future<void> uploadRating(Quote quote, int rating, User localUser) {
    String quoteID = quote.id.toString();

    return firestore.collection("quotes")
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

  Future<DocumentSnapshot> download(User localUser) {
    return firestore.collection("quotes")
        .doc(localUser.uid).get();
  }

  /// Downloadfirestore.collection("quotes")
  FutureBuilder<DocumentSnapshot> downloadPersonalQuotes(User localUser) {
    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection("quotes")
        .doc(localUser.uid).get(),
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
          return ListView(padding: EdgeInsets.all(8), children: cards);
        }

        return CircularProgressIndicator();
      },
    );
  }
}