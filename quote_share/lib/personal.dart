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

/// Implements Personal Widget
class Personal extends StatefulWidget{

    @override
  PersonalState createState() => new PersonalState();

}

/// Implements Personal State
class PersonalState extends State<Personal> {
  
  @override
  Widget build(BuildContext context) {
    return FirebaseConnection().downloadPersonalQuotes();
  }

}