import 'package:bookapp/constants.dart';
import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/models/request_model.dart';
import 'package:bookapp/src/pages/profile/purchase_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ManagePurchasesScreen extends StatelessWidget {
  const ManagePurchasesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage Purchases'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              ownerBookRef.collection(uid).orderBy('purchasedAt').snapshots(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: Text(
                'No Purchases',
                style: TextStyle(fontSize: 20, color: kPrimaryColor),
              ));
            }
            List<DocumentSnapshot> docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return const Center(
                  child: Text(
                'No Purchases',
                style: TextStyle(fontSize: 20, color: kPrimaryColor),
              ));
            } else {
              return ListView(
                children: List.generate(
                    docs.length,
                    (index) => ManagePurchasesWidget(
                        request: RequestModel.fromJson(docs[index]))),
              );
            }
          },
        ));
  }
}

class ManagePurchasesWidget extends StatelessWidget {
  const ManagePurchasesWidget({Key? key, required this.request})
      : super(key: key);
  final RequestModel request;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(() => PurchaseDetailsScreen(request: request));
      },
      leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(request.user!.imageUrl!)),
      title: Text(request.book!.name!),
      subtitle: Text(request.user!.fullName!),
      trailing: Text('KES ' + request.book!.price!.toString()),
    );
  }
}
