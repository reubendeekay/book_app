import 'package:bookapp/constants.dart';
import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/models/discussion_tile_model.dart';
import 'package:bookapp/src/models/message_model.dart';
import 'package:bookapp/src/models/user_model.dart';
import 'package:bookapp/src/pages/chat/add_message.dart';
import 'package:bookapp/src/pages/chat/chat_details_screen.dart';
import 'package:bookapp/src/pages/chat/widgets/chat_bubble.dart';
import 'package:bookapp/src/pages/chat/widgets/fullscreen_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatRoom extends StatelessWidget {
  ChatRoom({Key? key, required this.discussion, this.ownerId})
      : super(key: key);
  static const routeName = '/chat-room';
  final DiscussionTileModel discussion;
  final String? ownerId;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    build(BuildContext context) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollController
          .animateTo(_scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor.withOpacity(0.6),
        elevation: 2,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 25,
        title: GestureDetector(
          onTap: () {
            Get.to(() => ChatDetailsScreen(discussion: discussion));
          },
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                      () => FullscreenImage(image: discussion.book!.imgUrl!));
                },
                child: CircleAvatar(
                  radius: 21,
                  backgroundImage:
                      CachedNetworkImageProvider(discussion.book!.imgUrl!),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            discussion.title!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        // if (user.isAdmin!)
                        //   const Icon(
                        //     Icons.verified,
                        //     color: kPrimaryColor,
                        //     size: 16,
                        //   )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            discussion.description!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('discussions')
                    .doc(discussion.id!)
                    .collection('messages')
                    .orderBy('sentAt')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(child: Container());
                  }

                  return Expanded(
                    child: ListView.builder(
                      // reverse: true,
                      controller: _scrollController,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data!.docs[index];

                        build(context);
                        return uid == ownerId
                            ? Dismissible(
                                key: Key(message['sentAt'].toString()),
                                direction: uid != message['sender']
                                    ? DismissDirection.startToEnd
                                    : DismissDirection.endToStart,
                                background: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 7.5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  alignment: uid != message['sender']
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                ),
                                child: ChatBubble(
                                  MessageModel(
                                    message: message['message'],
                                    isRead: message['isRead'],
                                    sentAt: message['sentAt'],
                                    senderId: message['sender'],
                                    mediaType: message['mediaType'],
                                    mediaUrl: message['media'],
                                    fullName: message['name'] ?? 'User',
                                  ),
                                  ownerId!,
                                ),
                              )
                            : ChatBubble(
                                MessageModel(
                                  message: message['message'],
                                  isRead: message['isRead'],
                                  sentAt: message['sentAt'],
                                  senderId: message['sender'],
                                  mediaType: message['mediaType'],
                                  mediaUrl: message['media'],
                                  fullName: message['name'] ?? 'User',
                                ),
                                ownerId!,
                              );
                      },
                    ),
                  );
                }),
            AddMessage(
              userId: discussion.id!,
            ),
            const SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget moreVert() {
    return PopupMenuButton(
        elevation: 1,
        itemBuilder: (xtx) => options
            .map((e) => PopupMenuItem(
                    child: Text(
                  e,
                  style: const TextStyle(fontSize: 15),
                )))
            .toList(),
        icon: const Icon(
          Icons.more_vert,
          color: Colors.grey,
        ));
  }

  List options = [
    'Search',
    'Mute notifications',
    'Clear chat',
    'Report',
    'Block'
  ];
}
