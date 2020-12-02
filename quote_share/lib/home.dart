import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:quote_share/quote.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;
import 'package:quote_share/quote_card.dart';
import 'package:social_share/social_share.dart';

/// Implements Home Widget
class Home extends StatefulWidget {
  const Home({Key key, this.auth, this.firestore}) : super(key: key);
  
  /// Firebase authentication
  final FirebaseAuth auth;

  /// Firebase firestore
  final FirebaseFirestore firestore;

  @override
  HomeState createState() => new HomeState();
}

/// Implements Home State
class HomeState extends State<Home> {
  /// Future Quote
  Future<Quote> futureQuote;

  /// Current Quote
  Quote currentQuote;

  /// Quote Text
  String quoteText = "No Quote";

  /// Author Text
  String authorText = "No Author";

  @override
  void initState() {
    super.initState();
    refreshQuote();
  }

  /// Fetches Quote from server
  Future<Quote> fetchQuote() async {

    /// Response
    final response =
        await http.get('http://quotes.stormconsultancy.co.uk/random.json');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      createTextFromQuote();
      return Quote.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load quote');
    }
  }

  /// Refreshes quote
  void refreshQuote() {
    futureQuote = fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: 350,
          child: Column(children: [createTextFromQuote(), createButtonRow()])),
    );
  }

  /// Creates Text widget from quote
  FutureBuilder<Quote> createTextFromQuote() {
    return FutureBuilder<Quote>(
      future: futureQuote,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          currentQuote = snapshot.data;
          currentQuote.rating = 0;

          return new QuoteCard(
            quote: currentQuote,
            firestore: widget.firestore,
            user: widget.auth.currentUser,
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }

  /// Create Button Row
  Row createButtonRow() {

    /// Snackbar copied
    final copied = SnackBar(content: Text("Copied quote to clipboard"), backgroundColor: Colors.blue,);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(EvaIcons.refresh),
          tooltip: 'Refresh quote',
          onPressed: () {
            setState(() {
              refreshQuote();
            });
          },
        ),
        IconButton(
          icon: Icon(EvaIcons.twitter),
          onPressed: () async {
            SocialShare.shareTwitter(quoteText,
                hashtags: ["quotes", "developer", "funny", "inspiring"],
                url: "",
                trailingText: "");
          },
        ),
        IconButton(
          icon: Icon(EvaIcons.copyOutline),
          onPressed: () async {
            SocialShare.copyToClipboard(
              quoteText,
            );
            Scaffold.of(context).showSnackBar(copied);
          },
        )
      ],
    );
  }
}
