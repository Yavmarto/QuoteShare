import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quote_share/database.dart';
import 'package:firebase_auth/firebase_auth.dart';


/// Implements Personal Widget
class Personal extends StatefulWidget{
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
    return Database(firestore: widget.firestore).downloadPersonalQuotes(widget.auth.currentUser);
  }

}