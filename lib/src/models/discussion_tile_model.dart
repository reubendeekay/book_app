import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/models/user_model.dart';

class DiscussionTileModel {
  final BookModel? book;
  List<UserModel>? users;
  final String? id;
  final String? latestMessage;
  final String? sender;
  final String? title;
  final String? description;

  DiscussionTileModel(
      {this.book,
      this.id,
      this.latestMessage,
      this.users,
      this.sender,
      this.description,
      this.title});

  factory DiscussionTileModel.fromJson(dynamic json) {
    return DiscussionTileModel(
      book: BookModel.fromMap(json['book']),
      id: json.id,
      latestMessage: json['latestMessage'],
      users: json['users'] != null
          ? (json['users'] as List).map((i) => UserModel.fromJson(i)).toList()
          : null,
      sender: json['sentBy'],
      description: json['description'],
      title: json['title'],
    );
  }
}
