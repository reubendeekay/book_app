import 'dart:io';

import 'package:bookapp/src/models/message_model.dart';
import 'package:bookapp/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ChatTileModel {
  final UserModel? user;
  String? latestMessage;
  Timestamp? time;
  final String? latestMessageSenderId;
  final String? chatRoomId;

  ChatTileModel({
    this.user,
    this.latestMessage,
    this.time,
    this.chatRoomId,
    this.latestMessageSenderId,
  });
}

class ChatProvider with ChangeNotifier {
  /////////////////SEND MESSAGE////////////////////////
  Future<void> sendMessage(String bookId, MessageModel message) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String url = '';
    final chatRoom =
        FirebaseFirestore.instance.collection('discussions').doc(bookId);
    if (message.mediaFiles!.isNotEmpty) {
      await Future.forEach(message.mediaFiles!, (File element) async {
        final fileData = await FirebaseStorage.instance
            .ref('chatFiles/$uid/${DateTime.now().toIso8601String()}')
            .putFile(element);
        url = await fileData.ref.getDownloadURL();
      }).then((_) async {
        final chatRoom =
            FirebaseFirestore.instance.collection('discussions').doc(bookId);

        await chatRoom.update({
          'latestMessage':
              message.message!.isNotEmpty ? message.message : 'photo',
          'sentAt': Timestamp.now(),
          'sentBy': uid,
        });
        print(chatRoom.path);
        await chatRoom.collection('messages').doc().set({
          'message': message.message!.isNotEmpty ? message.message : 'photo',
          'sender': uid,
          'to': bookId,
          'media': url,
          'mediaType': message.mediaType,
          'isRead': false,
          'sentAt': Timestamp.now(),
          'name': message.fullName,
        });
      });
    } else {
      chatRoom.update({
        'latestMessage': message.message ?? 'photo',
        'sentAt': Timestamp.now(),
        'sentBy': uid,
      });
      chatRoom.collection('messages').doc().set({
        'message': message.message ?? '',
        'sender': uid,
        'to': bookId,
        'media': url,
        'mediaType': message.mediaType,
        'isRead': false,
        'sentAt': Timestamp.now(),
        'name': message.fullName,
      });
    }

    print('done');
    notifyListeners();
  }

  Future<List<ChatTileModel>> searchUser(String searchTerm) async {
    List<UserModel> users = [];

    final results = await FirebaseFirestore.instance.collection('users').get();
    results.docs
        .where((element) =>
            element['fullName']
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            element['phoneNumber']
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            element['fullName']
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .forEach((e) {
      users.add(UserModel(
        fullName: e['fullName'],
        imageUrl: e['profilePic'],
        userId: e['userId'],
        phoneNumber: e['phoneNumber'],
        lastSeen: e['lastSeen'],
        isOnline: e['isOnline'],
      ));
    });
    print(users.length);

    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return users.map((e) => ChatTileModel(user: e, chatRoomId: '')).toList();
  }
}
