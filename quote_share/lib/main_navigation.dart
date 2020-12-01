import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quote_share/auth.dart';


import 'package:quote_share/home.dart';
import 'package:quote_share/personal.dart';

/// Main Nagivation Widget
class MainNavigation extends StatefulWidget {
  MainNavigation({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MainNagivationState createState() => new MainNagivationState(title);
}

/// Main Navigation State
class MainNagivationState extends State<MainNavigation> {
  MainNagivationState(this.bartitle);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Bar title
  final String bartitle;

  /// Text style option
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  /// Selected index
  int _selectedIndex = 0;

  /// Navigation Options
  List<Widget> _widgetOptions = [];

  /// Switch selected index on tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth(auth: _auth).user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.uid == null) {
            const Scaffold(
              body: Center(
                child: Text("Error connecting, try again later..."),
              ),
            );
          } else {
            
            _widgetOptions.addAll([
              Home(firestore: _firestore, auth: _auth),
              Personal(firestore: _firestore, auth: _auth)
            ]);

            return app();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  /// Material app
  MaterialApp app() {
    return MaterialApp(
      title: bartitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(bartitle),
        ),
        body: _widgetOptions[_selectedIndex],
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
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
