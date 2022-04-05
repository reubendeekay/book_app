import 'package:bookapp/src/pages/detail/view_all_screen.dart';
import 'package:bookapp/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CategoryTitle extends StatelessWidget {
  const CategoryTitle(
      {Key? key, required this.title, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () {
              Get.to(() => ViewAllScreen(
                    settingsController: settingsController,
                  ));
            },
            child: Text(
              'View All',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
