import 'package:flutter/material.dart';

import 'package:quote_share/main_navigation.dart';


/// Implements Main Quote Share Widget
class QuoteShare extends StatelessWidget {
  /// Title
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