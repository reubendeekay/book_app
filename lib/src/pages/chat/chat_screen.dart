import 'package:bookapp/screens/providers/chat_provider.dart';
import 'package:bookapp/src/pages/chat/chat_screen_search.dart';
import 'package:bookapp/src/pages/chat/widgets/chat_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    const Text(
                      'Discussions',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          Get.to(() => const ChatScreenSearch());
                        },
                        child: const Icon(CupertinoIcons.search,
                            color: Colors.white)),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
            ],
          ),
          Expanded(
            child: ChatScreenWidget(),
          )
        ],
      ),
    );
  }
}

class ChatScreenWidget extends StatelessWidget {
  static const routeName = '/chat-screen-widget';
  final uid = FirebaseAuth.instance.currentUser!.uid;

  ChatScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatProvider>(context).getChats();

    final contacts = Provider.of<ChatProvider>(context).contactedUsers;

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        ...List.generate(
            contacts.length,
            (index) => ChatTile(
                  roomId: contacts[index].chatRoomId!,
                  chatModel: contacts[index],
                )),
        if (contacts.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'You have no unread messages',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'When you contact a other users or customer care, you will be able to see their messages here.',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
          )
      ],
    );
  }
}
