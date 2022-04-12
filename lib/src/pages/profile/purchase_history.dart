import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/models/request_model.dart';
import 'package:bookapp/src/pages/home/widget/book_tile.dart';
import 'package:bookapp/src/pages/profile/purchase_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchaseHistory extends StatelessWidget {
  const PurchaseHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Purchase History'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: purchasedBooksRef.orderBy('purchasedAt').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView(
            children: List.generate(
              docs.length,
              (index) => InkWell(
                onTap: () {
                  Get.to(() => PurchaseDetailsScreen(
                      request: RequestModel.fromJson(docs[index])));
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: BookTile(
                    isTappable: false,
                    book: BookModel.fromMap(docs[index]['book']),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
