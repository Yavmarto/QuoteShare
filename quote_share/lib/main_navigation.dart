import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quote_share/services/auth.dart';

import 'package:quote_share/pages/home.dart';
import 'package:quote_share/pages/personal.dart';

/// Implements Main Nagivation Widget
class MainNavigation extends StatefulWidget {
  MainNavigation({Key key, this.title}) : super(key: key);

  /// Title
  final String title;

  @override
  MainNagivationState createState() => new MainNagivationState(title);
}

/// Implements Main Navigation State
class MainNagivationState extends State<MainNavigation> {
  MainNagivationState(this.bartitle);

  /// Firebase authentication
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Firebase Firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Bar title
  final String bartitle;

  /// Text style option
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  /// Selected index
  int selectedIndex = 0;

  /// Navigation Options
  List<Widget> navigationOptions = [];

  /// Switch selected index on tap
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Add all navigation options
    navigationOptions.addAll([
      Home(firestore: firestore, auth: auth),
      Personal(firestore: firestore, auth: auth)
    ]);

    return StreamBuilder(
      stream: Auth(auth: auth).user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.uid == null) {
            const Scaffold(
              body: Center(
                child: Text("Error connecting, try again later..."),
              ),
            );
          } else {
            return createApp();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  /// Create Material app
  MaterialApp createApp() {
    return MaterialApp(
      title: bartitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(bartitle),
        ),
        body: navigationOptions[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'My Quotes',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
