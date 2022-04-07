import 'package:bookapp/constants.dart';
import 'package:bookapp/screens/providers/chat_provider.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/models/discussion_tile_model.dart';
import 'package:bookapp/src/models/user_model.dart';
import 'package:bookapp/src/pages/chat/chat_room.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatelessWidget {
  ChatTile({Key? key, required this.discussion}) : super(key: key);
  final DiscussionTileModel discussion;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigator.of(context).pushNamed(ChatRoom.routeName, arguments: {
        //   'chatRoomId': roomId,
        //   'user': book,
        // });
        Get.to(() => ChatRoom(discussion: discussion));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Row(children: [
              CircleAvatar(
                radius: 26,
                backgroundImage:
                    CachedNetworkImageProvider(discussion.book!.imgUrl!),
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
                          discussion.book!.name!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),

                        // Text(
                        //   book != null
                        //       ? DateFormat('HH:mm')
                        //           .format(book!.toDate())
                        //       : '',
                        //   style:
                        //       const TextStyle(fontSize: 13, color: Colors.grey),
                        // )
                      ],
                    ),
                    Text(
                      '${discussion.sender == uid ? 'You: ' : ''}${discussion.latestMessage}',
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
