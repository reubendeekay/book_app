import 'package:bookapp/src/pages/home/widget/custom_app_bar.dart';
import 'package:bookapp/src/pages/home/widget/buy_books_category.dart';
import 'package:bookapp/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';

class ViewAllScreen extends StatelessWidget {
  const ViewAllScreen({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        const SizedBox(
          height: 10,
        ),
        CustomAppBar(settingsController: settingsController),
        BuyBooks(
          isUserProfile: true,
          settingsController: settingsController,
        )
      ]),
    );
  }
}
