class Quote {
  final int id;
  final String author;
  final String content;

  Quote({this.id, this.author, this.content});

    factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      author: json['author'],
      content: json['quote'],
    );
  }



}