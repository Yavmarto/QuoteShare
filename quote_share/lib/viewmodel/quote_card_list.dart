import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quote_share/model/quote.dart';
import 'package:quote_share/services/database.dart';
import 'package:quote_share/viewmodel/quote_card.dart';

class QuoteCardList {
  List<QuoteCard> quotes = List<QuoteCard>();

  Future<List<QuoteCard>> fetchPersonalQuotes(
      FirebaseFirestore firestore, User localUser) async {
    final result =
        await Database(firestore: firestore).downloadQuotes(localUser);
    result.data().forEach((key, value) {
      Quote quote = new Quote(
          content: value["content"],
          author: value["author"],
          rating: value["rating"],
          id: value["id"]);
      quotes.add(
          new QuoteCard(firestore: firestore, quote: quote, user: localUser));
    });

    return quotes;
  }
}
