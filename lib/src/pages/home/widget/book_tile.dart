import 'package:bookapp/screens/helpers/cached_image.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/pages/detail/detail.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class BookTile extends StatelessWidget {
  const BookTile({Key? key, required this.book}) : super(key: key);
  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DetailPage(book: book));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            // color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10)),
        height: 120,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: book.id!,
                child: SizedBox(
                  height: 120,
                  child: cachedImage(
                    book.imgUrl!,
                    fit: BoxFit.cover,
                    width: 100,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.name!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Text(
                        book.description!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      book.tags!.join(", "),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
