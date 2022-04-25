import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/pages/home/widget/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, this.searchText}) : super(key: key);
  final String? searchText;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

String? searchText;

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              onChanged: (val) {
                setState(() {
                  searchText = val;
                });
              },
              onEditingComplete: () {
                Get.off(() => SearchScreen(
                      searchText: widget.searchText,
                    ));
              },
              onFieldSubmitted: (val) {
                Get.off(() => SearchScreen(
                      searchText: val,
                    ));
              },
              initialValue: widget.searchText,
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
            ),
          ),
          Expanded(
            child: FutureBuilder<List<BookModel>>(
              future: Provider.of<BookProvider>(context, listen: false)
                  .searchBook(widget.searchText!),
              builder: (ctx, data) {
                if (data.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (data.data!.isEmpty) {
                  return const Center(child: Text('No books found'));
                } else {
                  return ListView(
                    children: List.generate(data.data!.length,
                        (index) => BookTile(book: data.data![index])),
                  );
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}
