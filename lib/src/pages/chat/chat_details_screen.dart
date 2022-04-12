import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/models/discussion_tile_model.dart';
import 'package:bookapp/src/pages/home/widget/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChatDetailsScreen extends StatelessWidget {
  const ChatDetailsScreen({Key? key, required this.discussion})
      : super(key: key);
  final DiscussionTileModel discussion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text(
                discussion.title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: const Text(
                  'Description',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                )),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                discussion.description!,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BookTile(book: discussion.book!),
            const SizedBox(
              height: 20,
            ),
            Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Text(
                  discussion.users!.length.toString() + ' Admin',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                )),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView(
                children: List.generate(
                    discussion.users!.length,
                    (index) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                discussion.users![index].imageUrl!),
                          ),
                          title: Text(discussion.users![index].fullName!),
                          subtitle: Text(discussion.users![index].email!),
                        )),
              ),
            ),
            if (uid == discussion.users!.first.userId)
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                width: double.infinity,
                height: 48,
                child: RaisedButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Center(
                                  child: Text('Delete Discussion Group?',
                                      style: TextStyle(color: Colors.white))),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Lottie.asset(
                                      'assets/delete.json',
                                      height: 100,
                                    ),
                                    const Text(
                                        'Notice that this action is irreversible. Do you want to continue?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                              actions: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                const SizedBox(
                                  width: 120,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    allDiscussionsRef
                                        .doc(discussion.id)
                                        .delete();

                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Discussion deleted'),
                                    ));
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            ));
                  },
                  color: Colors.red,
                  child: const Text(
                    'Delete Group',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
