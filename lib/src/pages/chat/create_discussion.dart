import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/pages/home/widget/book_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateDiscussion extends StatelessWidget {
  const CreateDiscussion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Discussion'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select a book to start a discussion'),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream:
                      allBooksRef.where('ownerId', isEqualTo: uid).snapshots(),
                  builder: (ctx, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    List<DocumentSnapshot> docs = snapshot.data!.docs;
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      children: List.generate(
                          docs.length,
                          (index) => InkWell(
                                onTap: () async {
                                  await Provider.of<BookProvider>(context,
                                          listen: false)
                                      .createDiscussion(
                                    BookModel.fromJson(docs[index]),
                                  );
                                  Navigator.of(context).pop();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Discussion created'),
                                    ),
                                  );
                                },
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: BookTile(
                                    book: BookModel.fromJson(docs[index]),
                                  ),
                                ),
                              )),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
