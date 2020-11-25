import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quote_share/quote.dart';
import 'package:rating_bar/rating_bar.dart';


import 'package:social_share/social_share.dart';

void main() {
  runApp(QuoteShare());
}

class QuoteShare extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Moose home page3'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<Quote> futureAlbum;
  double _ratingStar = 0;
  double _ratingStarLong = 0;
  double _ratingSmile = 0;
  int _platformVersion = 1;
  String quoteText = "No Quote";

  @override
  void initState() {
    super.initState();
    refreshQuote();
  }

  Future<Quote> fetchQuote() async {
  final response = await http.get('http://quotes.stormconsultancy.co.uk/random.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    createBuilder();
    return Quote.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load quote');
  }
}

void refreshQuote() {
  futureAlbum = fetchQuote();
}

FutureBuilder<Quote> createBuilder() {
   return FutureBuilder<Quote>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                quoteText = snapshot.data.content;
                return Text(quoteText);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          );
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quote app'),
        ),
        body: Center(
          child: SizedBox(
          
          width: 350,

          child: Column 
            (children: [
          createBuilder(),
       
          
          Text(
            'Rating : $_ratingStar',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 8),
          RatingBar(
            onRatingChanged: (rating) => setState(() => _ratingStar = rating),
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
          ),
             IconButton(
            
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh quote',
            onPressed: () {
              setState(() {
                refreshQuote();
              });
            
            }, 
          ),Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Running on: $_platformVersion\n',
                  textAlign: TextAlign.center,
                ),
                
                RaisedButton(
                  onPressed: () async {
                    SocialShare.copyToClipboard(
                      "This is Social Share plugin",
                    ).then((data) {
                      print(data);
                    });
                  },
                  child: Text("Copy to clipboard"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareTwitter(
                            quoteText,
                            hashtags: ["quotes", "developer", "funny", "inspiring"],
                            url: "",
                            trailingText: "")
                        .then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on twitter"),
                ),
          ],
            )]) 
        ),
        )
      ),
    );
  }
}
