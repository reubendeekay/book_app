import 'package:bookapp/screens/helpers/cached_image.dart';
import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/pages/home/widget/book_card.dart';
import 'package:bookapp/src/pages/home/widget/book_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/pages/detail/detail.dart';
import 'package:bookapp/src/pages/home/widget/category_title.dart';
import 'package:bookapp/src/settings/settings_controller.dart';

class BorrowBooksCategory extends StatelessWidget {
  BorrowBooksCategory({Key? key, required this.settingsController})
      : super(key: key);
  final List<BookModel> booksRecommendedList = BookModel.generateCategoryList();
  final SettingsController settingsController;
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Column(
      children: [
        CategoryTitle(
          title: "Books for borrowing",
          settingsController: settingsController,
        ),
        SizedBox(
          height: _size.width > 900 ? 360 : 250,
          child: StreamBuilder<QuerySnapshot>(
              stream: allBooksRef
                  .where('retailType', isEqualTo: 'borrow')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                final List<DocumentSnapshot> docs = snapshot.data!.docs;
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  separatorBuilder: (_, index) => const SizedBox(
                    width: 5,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return BookCard(book: BookModel.fromJson(docs[index]));
                  },
                );
              }),
        )
      ],
    );
  }
}
