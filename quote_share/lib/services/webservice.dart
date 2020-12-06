import 'dart:convert';

import 'package:quote_share/model/quote.dart';
import 'package:http/http.dart' as http;

class Webservice {
  /// Fetches Quote from server
  Future<Quote> fetchQuote() async {
    /// Response
    final response =
        await http.get('http://quotes.stormconsultancy.co.uk/random.json');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      // createTextFromQuote();

      return Quote.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load quote');
    }
  }
}
