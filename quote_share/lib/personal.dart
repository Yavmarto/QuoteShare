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

class Peronal extends StatefulWidget{

    @override
  PersonalState createState() => new PersonalState();

}

class PersonalState extends State<Peronal> {
  
  @override
  Widget build(BuildContext context) {
    return FirebaseConnection().downloadPersonalQuotes();
  }

}