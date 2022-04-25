import 'package:bookapp/constants.dart';
import 'package:bookapp/screens/helpers/cached_image.dart';
import 'package:bookapp/screens/providers/auth_provider.dart';
import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/models/user_model.dart';
import 'package:bookapp/src/pages/home/widget/book_tile.dart';
import 'package:bookapp/src/pages/home/widget/buy_books_category.dart';
import 'package:bookapp/src/pages/profile/dashboard_top.dart';
import 'package:bookapp/src/settings/settings_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key, required this.settingsController})
      : super(key: key);
  static const routeName = '/user-dashboard';
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    Provider.of<BookProvider>(context).getAllPurchasedBooks();

    return Scaffold(
      body: Stack(
        children: [
          BackgroundDashboard(
            user: user,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardTop(),
              const SizedBox(
                height: 25,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Your Books',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: allBooksRef
                        .where('ownerId', isEqualTo: user.userId)
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
                            (index) => BookTile(
                                  book: BookModel.fromJson(docs[index]),
                                )),
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BackgroundDashboard extends StatelessWidget {
  const BackgroundDashboard({Key? key, this.user}) : super(key: key);
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
            height: size.height * 0.5,
            width: size.width,
            child: cachedImage(
              user!.imageUrl!,
              fit: BoxFit.cover,
            )),
        Container(
          height: size.height * 0.5,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              kPrimaryColor.withOpacity(0.1),
              kPrimaryColor.withOpacity(0.3),
              kPrimaryColor.withOpacity(0.5),
              kPrimaryColor.withOpacity(0.7),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
              Theme.of(context).scaffoldBackgroundColor,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        )
      ],
    );
  }
}
