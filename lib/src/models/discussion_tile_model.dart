import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/models/user_model.dart';

class DiscussionTileModel {
  final BookModel? book;
  List<UserModel>? users;
  final String? id;
  final String? latestMessage;

  DiscussionTileModel({this.book, this.id, this.latestMessage, this.users});

  factory DiscussionTileModel.fromJson(dynamic json) {
    return DiscussionTileModel(
      book: json['book'] != null ? BookModel.fromJson(json['book']) : null,
      id: json['id'],
      latestMessage: json['latestMessage'],
      users: json['users'] != null
          ? (json['users'] as List).map((i) => UserModel.fromJson(i)).toList()
          : null,
    );
  }
}
