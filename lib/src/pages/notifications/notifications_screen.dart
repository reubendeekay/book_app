import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/models/notification_model.dart';
import 'package:bookapp/src/pages/notifications/notifications_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/notifications';
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: userNotifications.orderBy('createdAt').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('No notifications'));
            }

            List<DocumentSnapshot> docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No notifications'));
            } else {
              return ListView(
                children: List.generate(
                    docs.length,
                    (index) => NotificationsTile(
                        notification: NotificationModel.fromJson(docs[index]))),
              );
            }
          }),
    );
  }
}
