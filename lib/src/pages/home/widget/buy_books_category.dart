import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/pages/home/widget/book_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/pages/detail/detail.dart';
import 'package:bookapp/src/pages/home/widget/category_title.dart';
import 'package:bookapp/src/settings/settings_controller.dart';

class BuyBooks extends StatelessWidget {
  BuyBooks(
      {Key? key, required this.settingsController, this.isUserProfile = false})
      : super(key: key);
  final List<BookModel> moviesTrendingList = BookModel.generateItemsList();
  final SettingsController settingsController;
  bool isUserProfile;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isUserProfile)
          CategoryTitle(
            title: "Books for buying",
            settingsController: settingsController,
          ),
        StreamBuilder<QuerySnapshot>(
            stream:
                allBooksRef.where('retailType', isEqualTo: 'buy').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              List<DocumentSnapshot> docs = snapshot.data!.docs;
              return ListView.separated(
                padding: EdgeInsets.all(isUserProfile ? 15 : 20),
                primary: false,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: docs.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return BookTile(
                    book: BookModel.fromJson(docs[index]),
                  );
                },
              );
            }),
      ],
    );
  }
}
