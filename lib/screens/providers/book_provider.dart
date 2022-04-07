import 'package:bookapp/src/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

final uid = FirebaseAuth.instance.currentUser!.uid;
final allBooksRef = FirebaseFirestore.instance.collection('books');
final allDiscussionsRef = FirebaseFirestore.instance.collection('discussions');
final purchasedBooksRef =
    FirebaseFirestore.instance.collection('userData/$uid/purchasedBooks');

class BookProvider with ChangeNotifier {
  Future<void> addBook(BookModel book) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await allBooksRef.add(book.toJson());
    await allDiscussionsRef.doc(book.id).set({
      'book': book.toJson(),
      'initiator': uid,
      'creator': uid,
      'startedAt': Timestamp.now(),
      'latestMessage': 'Created Discussion',
      'sentAt': Timestamp.now(),
      'sentBy': uid,
    });
  }

  Future<void> purchaseBook(BookModel book) async {
    purchasedBooksRef.add({
      ...book.toJson(),
      'purchasedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> createDiscussion(BookModel book) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final results = await allDiscussionsRef.doc(book.id).get();
    if (!results.exists) {
      await allDiscussionsRef.doc(book.id).set({
        'book': book.toJson(),
        'initiator': uid,
        'creator': uid,
        'startedAt': Timestamp.now(),
        'latestMessage': 'Created Discussion',
        'sentAt': Timestamp.now(),
        'sentBy': uid,
      });
    }
  }
}
