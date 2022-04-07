import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/screens/providers/chat_provider.dart';
import 'package:bookapp/src/models/discussion_tile_model.dart';
import 'package:bookapp/src/pages/chat/create_discussion.dart';
import 'package:bookapp/src/pages/chat/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const CreateDiscussion());
                      },
                      child: Row(
                        children: const [
                          Text('Create'),
                          Icon(Icons.add),
                        ],
                      ),
                    ),
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
    return StreamBuilder<QuerySnapshot>(
        stream: allDiscussionsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'There are no discussion groups',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'When you join a discussion group or contact customer customer care, you will be able to see their messages here.',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            );
          }

          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView(
            padding: const EdgeInsets.all(0),
            children: [
              ...List.generate(
                  docs.length,
                  (index) => ChatTile(
                        discussion: DiscussionTileModel.fromJson(docs[index]),
                      )),
            ],
          );
        });
  }
}
