import 'package:bookapp/constants.dart';
import 'package:bookapp/screens/helpers/my_loader.dart';
import 'package:bookapp/screens/providers/auth_provider.dart';
import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/pages/add_book/widgets/my_text_field.dart';
import 'package:bookapp/src/pages/home/widget/book_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateDiscussion extends StatefulWidget {
  const CreateDiscussion({Key? key}) : super(key: key);

  @override
  State<CreateDiscussion> createState() => _CreateDiscussionState();
}

class _CreateDiscussionState extends State<CreateDiscussion> {
  String? title, description;
  BookModel? selectedBook;
  int? selectedIndex;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Discussion'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextField(
                  hint: 'Discussion group title',
                  onChanged: (val) {
                    setState(() {
                      title = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  hint: 'About Group',
                  onChanged: (val) {
                    setState(() {
                      description = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('Select a book to start a discussion'),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: allBooksRef
                          .where('ownerId', isEqualTo: uid)
                          .snapshots(),
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
                                      setState(() {
                                        selectedBook =
                                            BookModel.fromJson(docs[index]);
                                      });
                                      selectedIndex = index;
                                    },
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: Container(
                                        color: selectedIndex == index
                                            ? kPrimaryColor.withOpacity(0.2)
                                            : null,
                                        child: BookTile(
                                          book: BookModel.fromJson(docs[index]),
                                        ),
                                      ),
                                    ),
                                  )),
                        );
                      }),
                ),
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 48,
                  child: RaisedButton(
                    color: kPrimaryColor,
                    child: isLoading
                        ? const MyLoader()
                        : const Text('Create Group'),
                    onPressed: title != null &&
                            description != null &&
                            selectedBook != null
                        ? () async {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              await Provider.of<BookProvider>(context,
                                      listen: false)
                                  .createDiscussion(selectedBook!, user, title!,
                                      description!);
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).pop();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Discussion created'),
                                ),
                              );
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        : null,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
