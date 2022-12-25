import 'user.dart';

class Comment {
  final int id;
  final String text;
  final DateTime date;
  final User author;

  const Comment(this.id, this.text, this.date, this.author);

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        date = DateTime.DateTime.fromMillisecondsSinceEpoch(json['date'],
            isUtc: true),
        author = User.fromJson(json['author']);
}
