import 'package:flutter/material.dart';

// Implements Quote Card
class QuoteCard extends StatelessWidget {
  QuoteCard(this.content, this.author);

  final String content;
  final String author;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.short_text),
            title: Text(content),
            subtitle: Text(author),
          )
        ],
      ),
    );
  }
}
