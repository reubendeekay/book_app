import 'dart:io';

import 'package:bookapp/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  UserModel get user => _user!;
  bool isOnline = false;

  Future<void> login({String? email, String? password}) async {
    final UserCredential _currentUser = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
    await FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'pushToken': token});
    }).catchError((err) {});

    await getCurrentUser(_currentUser.user!.uid);

    notifyListeners();
  }

  Future<void> signUp(
      {String? email,
      String? password,
      String? fullName,
      String? phoneNumber}) async {
    final UserCredential _currentUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.user!.uid)
        .set({
      'userId': _currentUser.user!.uid,
      'email': email,
      'createdAt': Timestamp.now(),
      'password': password,
      'fullName': fullName,
      'isOnline': true,
      'lastSeen': Timestamp.now().millisecondsSinceEpoch,
      'phoneNumber': phoneNumber,
      'isAdmin': false,
      'balance': 0,
      'profilePic':
          'https://www.theupcoming.co.uk/wp-content/themes/topnews/images/tucuser-avatar-new.png',
    });
    await FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'pushToken': token});
    }).catchError((err) {});
    await getCurrentUser(_currentUser.user!.uid);

    notifyListeners();
  }

  Future<void> getCurrentUser(String userId) async {
    final _currentUser =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    _user = UserModel(
      email: _currentUser['email'],
      phoneNumber: _currentUser['phoneNumber'],
      imageUrl: _currentUser['profilePic'],
      isAdmin: _currentUser['isAdmin'],
      fullName: _currentUser['fullName'],
      userId: _currentUser['userId'],
      isOnline: _currentUser['isOnline'],
      lastSeen: _currentUser['lastSeen'],
      password: _currentUser['password'],
      balance: double.parse(_currentUser['balance'].toString()),
    );

    notifyListeners();
  }

  Future<void> updateProfile(UserModel user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update({
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'fullName': user.fullName,
    });
    notifyListeners();
  }

  Future<void> getOnlineStatus() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final databaseRef = FirebaseDatabase.instance.ref('users/$uid');
    if (!isOnline) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'isOnline': true,
        'lastSeen': DateTime.now().microsecondsSinceEpoch,
      });
      databaseRef.update({
        'isOnline': true,
        'lastSeen': DateTime.now().microsecondsSinceEpoch,
      });
      isOnline = true;
    }

    databaseRef.onDisconnect().update({
      'isOnline': false,
      'lastSeen': DateTime.now().microsecondsSinceEpoch,
    }).then((_) => {
          isOnline = false,
        });

    notifyListeners();
  }

  Future<void> updateProfilePic(File image) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final results =
        await FirebaseStorage.instance.ref('profilePics/$uid').putFile(image);

    final value = await results.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'profilePic': value,
    });

    notifyListeners();
  }

  Future<void> editProfile(UserModel user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update({
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'fullName': user.fullName,
    });
    notifyListeners();
  }

  Future<void> makeAdmin(String uid, bool isAdmin) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isAdmin': !isAdmin,
    });
    notifyListeners();
  }
}
