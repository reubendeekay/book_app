import 'package:bookapp/src/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

final uid = FirebaseAuth.instance.currentUser!.uid;
final allBooksRef = FirebaseFirestore.instance.collection('books');
final purchasedBooksRef =
    FirebaseFirestore.instance.collection('userData/$uid/purchasedBooks');

class BookProvider with ChangeNotifier {
  Future<void> addBook(BookModel book) async {
    allBooksRef.add(book.toJson());
  }

  Future<void> purchaseBook(BookModel book) async {
    purchasedBooksRef.add({
      ...book.toJson(),
      'purchasedAt': DateTime.now().toIso8601String(),
    });
  }
}
