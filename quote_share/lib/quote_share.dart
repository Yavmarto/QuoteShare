import 'package:flutter/material.dart';

import 'package:quote_share/main_navigation.dart';


/// Main Quote Share Widget
class QuoteShare extends StatelessWidget {
  final String title = "Quote Share";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            title: title,
            theme: ThemeData(
              primarySwatch: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MainNavigation(title: title),
          );
  }
}