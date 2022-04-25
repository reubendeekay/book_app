import 'package:bookapp/screens/helpers/cached_image.dart';
import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/pages/detail/detail.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class BookCard extends StatelessWidget {
  const BookCard({Key? key, required this.book}) : super(key: key);
  final BookModel book;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Provider.of<BookProvider>(context, listen: false).addView(book.id!);

        Get.to(() => DetailPage(book: book));
      },
      child: Stack(
        children: [
          SizedBox(
            width: _size.width > 800 ? 240 : 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: book.id!,
                      child: cachedImage(
                        book.imgUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    book.name!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  book.author!,
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          Positioned(left: 5, top: 5, child: _buildStar(book.review!))
        ],
      ),
    );
  }

  Widget _buildStar(String star) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.black54, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.orange[300],
            size: 14,
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            star,
            style: const TextStyle(color: Colors.white70),
          )
        ],
      ),
    );
  }
}
