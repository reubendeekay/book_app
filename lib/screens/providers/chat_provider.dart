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
  List<ChatTileModel> _contactedUsers = [];

  List<ChatTileModel> get contactedUsers => [..._contactedUsers];

  /////////////////SEND MESSAGE////////////////////////
  Future<void> sendMessage(String userId, MessageModel message) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String url = '';

    if (message.mediaFiles!.isNotEmpty) {
      await Future.forEach(message.mediaFiles!, (File element) async {
        final fileData = await FirebaseStorage.instance
            .ref('chatFiles/$uid/${DateTime.now().toIso8601String()}')
            .putFile(element);
        url = await fileData.ref.getDownloadURL();
      }).then((_) async {
        final chatRoom =
            FirebaseFirestore.instance.collection('discussions').doc(userId);

        chatRoom.update({
          'latestMessage':
              message.message!.isNotEmpty ? message.message : 'photo',
          'sentAt': Timestamp.now(),
          'sentBy': uid,
        });
        chatRoom.collection('messages').doc().set({
          'message': message.message!.isNotEmpty ? message.message : 'photo',
          'sender': uid,
          'to': userId,
          'media': url,
          'mediaType': message.mediaType,
          'isRead': false,
          'sentAt': Timestamp.now()
        });
      });
    }
    notifyListeners();
  }

  //////////////////////////////////////////////////////
  ///
  ///
  Future<void> getChats() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    List<ChatTileModel> users = [];

    final initiatorChats = await FirebaseFirestore.instance
        .collection('chats')
        .where('initiator', isEqualTo: uid)
        .get();
    final receiverChats = await FirebaseFirestore.instance
        .collection('chats')
        .where('receiver', isEqualTo: uid)
        .get();

    await Future.forEach(initiatorChats.docs,
        (QueryDocumentSnapshot element) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(element['receiver'])
          .get()
          .then((value) => {
                // print(value['username']),
                if (value.exists)
                  {
                    users.add(ChatTileModel(
                      chatRoomId: element.id,
                      latestMessageSenderId: element['sentBy'],
                      user: UserModel(
                        fullName: value['fullName'],
                        imageUrl: value['profilePic'],
                        userId: value['userId'],
                        phoneNumber: value['phoneNumber'],
                        lastSeen: value['lastSeen'],
                        isOnline: value['isOnline'],
                      ),
                    )),
                  }
              });
    });

    await Future.forEach(receiverChats.docs,
        (QueryDocumentSnapshot element) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(element['initiator'])
          .get()
          .then((value) => {
                if (value.exists)
                  {
                    users.add(
                      ChatTileModel(
                        chatRoomId: element.id,
                        latestMessageSenderId: element['sentBy'],
                        user: UserModel(
                          fullName: value['fullName'],
                          imageUrl: value['profilePic'],
                          userId: value['userId'],
                          phoneNumber: value['phoneNumber'],
                          lastSeen: value['lastSeen'],
                          isOnline: value['isOnline'],
                        ),
                      ),
                    )
                  }
              });
    });
    users.sort((a, b) => b.time!.compareTo(a.time!));

    _contactedUsers = users;

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
