import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/models/request_model.dart';
import 'package:bookapp/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

final uid = FirebaseAuth.instance.currentUser!.uid;
final allBooksRef = FirebaseFirestore.instance.collection('books');
final allDiscussionsRef = FirebaseFirestore.instance.collection('discussions');
final purchasedBooksRef =
    FirebaseFirestore.instance.collection('userData/$uid/purchasedBooks');
final ownerBookRef = FirebaseFirestore.instance.doc('userData/requests');

final userNotifications =
    FirebaseFirestore.instance.collection('userData/$uid/notifications');
final bookOwnerNotification = FirebaseFirestore.instance.collection('userData');

class BookProvider with ChangeNotifier {
  Future<void> addBook(BookModel book, UserModel user) async {
    await allBooksRef.add(book.toJson());
  }

  Future<void> updateBook(BookModel book, UserModel user) async {
    await allBooksRef.doc(book.id).update(book.toJson());
  }

  Future<void> purchaseBook(RequestModel request) async {
    final id = purchasedBooksRef.doc().id;
    await purchasedBooksRef.doc(id).set(request.toJson());
    await ownerBookRef
        .collection(request.book!.ownerId!)
        .doc(id)
        .set(request.toJson());
    await userNotifications.add({
      'message':
          '${request.book!.name} has been purchased. Wait for the owner to confirm and call.',
      'createdAt': Timestamp.now(),
      'id': id,
      'imageUrl': request.book!.imgUrl,
    });

    await bookOwnerNotification
        .doc(request.book!.ownerId!)
        .collection('notifications')
        .add({
      'message':
          '${request.book!.name} has book purchased by ${request.user!.fullName} phone number ${request.phoneNumber}. Please contact them for more details',
      'createdAt': Timestamp.now(),
      'id': id,
      'imageUrl': request.book!.imgUrl,
    });
  }

  Future<void> createDiscussion(
      BookModel book, UserModel user, String title, String description) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final results = await allDiscussionsRef.doc(book.id).get();
    if (!results.exists) {
      await allDiscussionsRef.doc(book.id).set({
        'book': book.toJson(),
        'initiator': uid,
        'creator': uid,
        'users': [
          user.toJson(),
        ],
        'startedAt': Timestamp.now(),
        'latestMessage': 'Created Discussion',
        'sentAt': Timestamp.now(),
        'sentBy': uid,
        'title': title,
        'description': description,
      });
    }
  }
}
