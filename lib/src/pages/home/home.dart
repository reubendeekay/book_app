import 'package:bookapp/screens/providers/auth_provider.dart';
import 'package:bookapp/src/pages/chat/chat_screen.dart';
import 'package:bookapp/src/pages/profile/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/src/pages/home/widget/custom_app_bar.dart';
import 'package:bookapp/src/pages/home/widget/top_books.dart';
import 'package:bookapp/src/pages/home/widget/borrow_books_categoty.dart';
import 'package:bookapp/src/pages/home/widget/buy_books_category.dart';
import 'package:bookapp/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context)
        .getCurrentUser(FirebaseAuth.instance.currentUser!.uid);

    return Scaffold(
      body: PageView(
          onPageChanged: ((value) => setState(() {
                currentIndex = value;
              })),
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            Home(settingsController: widget.settingsController),
            const ChatScreen(),
            UserProfile(settingsController: widget.settingsController)
          ]),
      bottomNavigationBar: _buildBottonBar(),
    );
  }

  BottomNavigationBar _buildBottonBar() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
              currentIndex = index;
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn);
            }),
        selectedItemColor: const Color(0xFF6741FF),
        items: const [
          BottomNavigationBarItem(
              label: 'Home', icon: Icon(Icons.home_rounded)),
          BottomNavigationBarItem(
              label: 'Book', icon: Icon(Icons.menu_book_rounded)),
          BottomNavigationBarItem(
              label: 'User Profile', icon: Icon(Icons.person_outline)),
        ]);
  }
}

class Home extends StatelessWidget {
  const Home({Key? key, required this.settingsController}) : super(key: key);
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomAppBar(settingsController: settingsController),
          TopBooks(
            settingsController: settingsController,
          ),
          BorrowBooksCategory(settingsController: settingsController),
          BuyBooks(
            settingsController: settingsController,
          ),
        ],
      ),
    );
  }
}
