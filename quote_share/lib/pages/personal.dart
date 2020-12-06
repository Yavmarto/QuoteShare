import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quote_share/viewmodel/quote_card.dart';
import 'package:quote_share/viewmodel/quote_card_list.dart';

/// Implements Personal Widget
class Personal extends StatefulWidget {
  const Personal({Key key, this.auth, this.firestore}) : super(key: key);

  /// Firebase authentication
  final FirebaseAuth auth;

  /// Firebase firestore
  final FirebaseFirestore firestore;

  @override
  PersonalState createState() => new PersonalState();
}

/// Implements Personal State
class PersonalState extends State<Personal> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuoteCard>>(
        future: QuoteCardList()
            .fetchPersonalQuotes(widget.firestore, widget.auth.currentUser),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return ListView(
                padding: EdgeInsets.all(8), children: snapshot.data);
          }
          return Center(child: Text("You have no personal quotes yet"),);
        });
  }
}
