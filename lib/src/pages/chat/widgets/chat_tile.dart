import 'package:bookapp/constants.dart';
import 'package:bookapp/screens/providers/chat_provider.dart';
import 'package:bookapp/src/models/user_model.dart';
import 'package:bookapp/src/pages/chat/chat_room.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatelessWidget {
  final String? roomId;
  final ChatTileModel? chatModel;
  ChatTile({Key? key, this.roomId, this.chatModel}) : super(key: key);
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigator.of(context).pushNamed(ChatRoom.routeName, arguments: {
        //   'chatRoomId': roomId,
        //   'user': chatModel!.user,
        // });
        final users =
            Provider.of<ChatProvider>(context, listen: false).contactedUsers;
        List<String> room = users.map<String>((e) {
          return e.chatRoomId!.contains(FirebaseAuth.instance.currentUser!.uid +
                  '_' +
                  chatModel!.user!.userId!)
              ? FirebaseAuth.instance.currentUser!.uid +
                  '_' +
                  chatModel!.user!.userId!
              : chatModel!.user!.userId! +
                  '_' +
                  FirebaseAuth.instance.currentUser!.uid;
        }).toList();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(chatModel!.user!.userId!)
            .get()
            .then((value) {
          Navigator.of(context).pushNamed(ChatRoom.routeName, arguments: {
            'user': UserModel(
              userId: value['userId'],
              fullName: value['fullName'],
              imageUrl: value['profilePic'],
              isAdmin: value['isAdmin'],
              lastSeen: value['lastSeen'],
              isOnline: value['isOnline'],
            ),
            'chatRoomId': room.first,
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Row(children: [
              CircleAvatar(
                radius: 26,
                backgroundImage:
                    CachedNetworkImageProvider(chatModel!.user!.imageUrl!),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          chatModel!.user!.fullName!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (chatModel!.user!.isAdmin!)
                          const Icon(
                            Icons.verified,
                            color: kPrimaryColor,
                            size: 16,
                          ),
                        const Spacer(),
                        Text(
                          chatModel!.time != null
                              ? DateFormat('HH:mm')
                                  .format(chatModel!.time!.toDate())
                              : '',
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        )
                      ],
                    ),
                    Text(
                      '${chatModel!.latestMessageSenderId == uid ? 'You: ' : ''}${chatModel!.latestMessage}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ]),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              height: 1,
            )
          ],
        ),
      ),
    );
  }
}
