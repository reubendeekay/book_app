import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final BookModel? book;
  final String? phoneNumber;
  final String? address;
  final String? instructions;
  final Timestamp? purchasedAt;
  final UserModel? user;

  RequestModel(
      {this.book,
      this.phoneNumber,
      this.address,
      this.instructions,
      this.user,
      this.purchasedAt});

  factory RequestModel.fromJson(dynamic json) {
    return RequestModel(
      book: json['book'] != null ? BookModel.fromMap(json['book']) : null,
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      instructions: json['instructions'],
      purchasedAt: json['purchasedAt'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'book': book?.toMap(),
        'phoneNumber': phoneNumber,
        'address': address,
        'instructions': instructions,
        'purchasedAt': purchasedAt,
        'user': user?.toJson(),
      };
}
