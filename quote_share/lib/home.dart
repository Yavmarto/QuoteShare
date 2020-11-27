import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quote_share/firebase_connection.dart';
import 'package:quote_share/quote.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;
import 'package:quote_share/quote_card.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:social_share/social_share.dart';


/// Implements Home Widget
class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

/// Implements Home State
class HomeState extends State<Home> {
  /// Future Quote
  Future<Quote> futureQuote;

  /// Current Quote
  Quote currentQuote;

  /// Star Rating
  int _ratingStar = 0;

  /// Platform version
  int _platformVersion = 1;

  /// Quote Text
  String quoteText = "No Quote";

  /// Author Text
  String authorText = "No Author";

  @override
  void initState() {
    super.initState();
    signIn();
  }

  /// Sign in Anonymously
  void signIn() {
    FirebaseConnection().auth.authStateChanges().listen((User user) {
      FirebaseConnection().localUser = user;
      if (user != null) {
        setState(() {
          refreshQuote();
        });
        print("signed in");
      }
    });

    FirebaseConnection().signIn();
  }

  /// Add Rating to database
  void addRating() {
    FirebaseConnection().uploadRating(currentQuote, _ratingStar);
  }

  /// Fetches Quote from server
  Future<Quote> fetchQuote() async {
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

  /// Creates Text widget from quote
  FutureBuilder<Quote> createTextFromQuote() {
    return FutureBuilder<Quote>(
      future: futureQuote,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          currentQuote = snapshot.data;
          quoteText = snapshot.data.content;
          authorText = snapshot.data.author;
          return QuoteCard(quoteText, authorText);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: 350,
          child: Column(children: [
            createTextFromQuote(),
            Text(
              'Rating : $_ratingStar',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 8),
            RatingBar(
              onRatingChanged: (rating) =>
                  setState(() => _ratingStar = rating.toInt()),
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh quote',
              onPressed: () {
                setState(() {
                  refreshQuote();
                });
              },
            ),
            IconButton(
                icon: Icon(Icons.upload_file),
                onPressed: () {
                  setState(() {
                    addRating();
                  });
                }),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Running on: $_platformVersion\n',
                  textAlign: TextAlign.center,
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.copyToClipboard(
                      "This is Social Share plugin",
                    ).then((data) {
                      print(data);
                    });
                  },
                  child: Text("Copy to clipboard"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareTwitter(quoteText,
                            hashtags: [
                              "quotes",
                              "developer",
                              "funny",
                              "inspiring"
                            ],
                            url: "",
                            trailingText: "")
                        .then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on twitter"),
                ),
              ],
            )
          ])),
    );
  }
}
