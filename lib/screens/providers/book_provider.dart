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
  List<RequestModel> _books = [];
  List<RequestModel> get books => [..._books];

  Future<void> addBook(BookModel book, UserModel user) async {
    await allBooksRef.add(book.toJson());
  }

  Future<void> updateBook(BookModel book, UserModel user) async {
    await allBooksRef.doc(book.id).update(book.toJson());
  }

  Future<void> addView(String bookId) async {
    await allBooksRef.doc(bookId).update({
      'view': FieldValue.increment(1),
    });
  }

  Future<void> deleteBook(BookModel book) async {
    final results = await FirebaseFirestore.instance.collection('users').get();
    print('RESULTS ' + results.docs.toString());
    await Future.wait(results.docs.map((result) async {
      final userBooks = await FirebaseFirestore.instance
          .collection('userData')
          .doc(result.id)
          .collection('purchasedBooks')
          .get();

      final wantedBooks = userBooks.docs.where(
        (element) => element['book']['id'] == book.id,
      );

      if (wantedBooks.isNotEmpty) {
        await Future.wait(wantedBooks.map((e) => FirebaseFirestore.instance
            .collection('userData')
            .doc(result.id)
            .collection('purchasedBooks')
            .doc(e.id)
            .delete()));
      }
    }));

    final admin = await FirebaseFirestore.instance
        .collection('userData/requests/$uid')
        .get();

    final adminBook =
        admin.docs.firstWhere((element) => element['book']['id'] == book.id);
    await adminBook.reference.delete();
    await allBooksRef.doc(book.id).delete();

    notifyListeners();
  }

  Future<void> purchaseBook(RequestModel request) async {
    final id = purchasedBooksRef.doc().id;
    await purchasedBooksRef.doc(id).set(request.toJson());
    await ownerBookRef
        .collection(request.book!.ownerId!)
        .doc(id)
        .set(request.toJson());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(request.book!.ownerId!)
        .update({
      'balance': FieldValue.increment(double.parse(request.book!.price!)),
    });
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

  Future<void> getAllPurchasedBooks() async {
    final results = await ownerBookRef.collection(uid).get();

    _books =
        results.docs.map((doc) => RequestModel.fromJson(doc.data())).toList();

    notifyListeners();
  }

  Future<List<BookModel>> searchBook(String search) async {
    final results = await allBooksRef.get();

    final list = results.docs
        .where((element) =>
            element['name']
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase()) ||
            element['author']
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase()) ||
            element['description']
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase()) ||
            element['tags'].contains(search.toLowerCase()))
        .toList();

    print(list.length);
    return list.map((element) => BookModel.fromMap(element.data())).toList();
  }
}
