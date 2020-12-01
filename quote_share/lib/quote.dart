
/// Implements Quote Object
class Quote {

  /// Quote ID
  final int id;

  /// Author
  final String author;

  /// Content
  final String content;

  /// Rating
  int rating = 0;

  Quote({this.id, this.author, this.content, this.rating});

    factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      author: json['author'],
      content: json['quote'],
    );
  }
}