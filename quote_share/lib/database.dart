import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quote_share/quote.dart';
import 'package:quote_share/quote_card.dart';

/// Implements Database class
class Database {
  Database({this.firestore});

  /// Firestore
  final FirebaseFirestore firestore;

  /// Save new quote with rating to database
  Future<void> uploadRating(Quote quote, User localUser, BuildContext context) {
    /// Quote ID
    String quoteID = quote.id.toString();

    /// Snackbar success
    final snackBarSuccess = createSnackbar('Quote has been saved');

    /// Snackbar failed
    final snackBarFailed = createSnackbar('Failed to save the Quote');

    return firestore
        .collection("quotes")
        .doc(localUser.uid)
        .update({
          quoteID: {
            'id': quote.id,
            'author': quote.author,
            'content': quote.content,
            'rating': quote.rating
          }
        })
        .then((value) => Scaffold.of(context).showSnackBar(snackBarSuccess))
        .catchError(
            (error) => Scaffold.of(context).showSnackBar(snackBarFailed));
  }

  /// Create snackbar
  SnackBar createSnackbar(String text) {
    return SnackBar(content: Text(text), backgroundColor: Colors.blue);
  }

  /// Download quotes
  Future<DocumentSnapshot> downloadQuotes(User localUser) {
    return firestore.collection("quotes").doc(localUser.uid).get();
  }

  /// Download personal quotes
  FutureBuilder<DocumentSnapshot> downloadPersonalQuotes(User localUser) {
    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection("quotes").doc(localUser.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData) {
          List<QuoteCard> cards = [];

          snapshot.data.data().forEach((key, value) {
            Quote quote = new Quote(
                content: value["content"],
                author: value["author"],
                rating: value["rating"],
                id: value["id"]);
            cards.add(new QuoteCard(
                firestore: firestore, quote: quote, user: localUser));
          });
          return ListView(padding: EdgeInsets.all(8), children: cards);
        }

        return CircularProgressIndicator();
      },
    );
  }
}
