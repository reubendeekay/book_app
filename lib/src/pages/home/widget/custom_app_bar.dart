import 'package:bookapp/src/pages/add_book/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/src/settings/settings_controller.dart';
import 'package:get/route_manager.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? searchText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            onChanged: (val) {
              setState(() {
                searchText = val;
              });
            },
            onEditingComplete: () {
              Get.to(() => SearchScreen(
                    searchText: searchText,
                  ));
            },
            onFieldSubmitted: (val) {
              Get.to(() => SearchScreen(
                    searchText: val,
                  ));
            },
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                prefixIcon: const Icon(Icons.search_outlined),
                hintText: 'Search book..'),
          )),
          IconButton(
            onPressed: () {
              widget.settingsController.updateThemeMode(
                  widget.settingsController.themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light);
            },
            icon: Icon(widget.settingsController.themeMode == ThemeMode.light
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded),
          )
        ],
      ),
    );
  }
}
