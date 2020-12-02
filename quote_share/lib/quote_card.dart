import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quote_share/database.dart';
import 'package:quote_share/quote.dart';
import 'package:rating_bar/rating_bar.dart';



/// Implements Home Widget
class QuoteCard extends StatefulWidget {

  /// Quote
  final Quote quote;

  /// Firestore
  final FirebaseFirestore firestore;

  /// Authentication
  final User user;

  QuoteCard({Key key, this.quote, this.firestore, this.user}): super(key: key);

  @override
  QuoteCardState createState() => new QuoteCardState(quote);
}

/// Implements Home State
class QuoteCardState extends State<QuoteCard> {  
  /// Quote
  Quote quote;

  QuoteCardState(this.quote);


  /// Add Rating to database
  void addRating(int rating, BuildContext context) {
    quote.rating = rating;
    Database(firestore: widget.firestore)
        .uploadRating(quote, widget.user, context);
  }

 @override
  Widget build(BuildContext context) {
  
    if (quote.rating == null) {
      quote.rating = 0;
    }

    return Center(
      child:
    Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.short_text),
            title: Text(widget.quote.content),
            subtitle: Text(widget.quote.author),
          ),
          SizedBox(height: 8),
         getRatingBar(context)
        ],
      ),
    )); 
  }

  /// Get rating bar
  RatingBar getRatingBar(BuildContext context) {
    return new RatingBar(
            initialRating: quote.rating.toDouble(),
            onRatingChanged: (rating) {
              addRating(rating.toInt(), context);
            },
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
          );
  }
}
