import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:async';

import 'package:quote_share/home.dart';
import 'package:quote_share/personal.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(QuoteShare());
}

// Main Quote Share Widget
class QuoteShare extends StatelessWidget {
  final String title = "Quote Share";

  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // handle error
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: title,
            theme: ThemeData(
              primarySwatch: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MainNavigation(title: title),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return  CircularProgressIndicator();
      },
    );
  }
}

// Main Nagivation
class MainNavigation extends StatefulWidget {
  MainNavigation({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MainNagivationState createState() => new MainNagivationState(title);
}

// Main Navigation State
class MainNagivationState extends State<MainNavigation> {
  MainNagivationState(this.bartitle);

  final String bartitle;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  int _selectedIndex = 0;
  
  List<Widget> _widgetOptions = [
    Home(),
    Text(
      'Index 1: Test',
      style: optionStyle,
    ),
    Peronal(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              icon: Icon(Icons.people),
              label: 'Rated Quotes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'My Quotes',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
