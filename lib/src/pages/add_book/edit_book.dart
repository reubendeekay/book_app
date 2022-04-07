import 'dart:io';

import 'package:bookapp/constants.dart';
import 'package:bookapp/screens/helpers/cached_image.dart';
import 'package:bookapp/screens/helpers/my_image_picker.dart';
import 'package:bookapp/screens/helpers/my_loader.dart';
import 'package:bookapp/screens/providers/auth_provider.dart';
import 'package:bookapp/screens/providers/book_provider.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/pages/add_book/widgets/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBookScreen extends StatefulWidget {
  const EditBookScreen({Key? key, required this.book}) : super(key: key);
  final BookModel book;

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  String? bookTitle, bookAuthor, bookDescription, bookPrice, retailType, tags;
  File? bookImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              openImagePicker(context, (val) {
                setState(() {
                  bookImage = val;
                });
              });
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: bookImage == null
                    ? cachedImage(
                        widget.book.imgUrl!,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        bookImage!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hint: widget.book.name!,
            onChanged: (val) {
              setState(() {
                bookTitle = val;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hint: widget.book.author!,
            onChanged: (val) {
              setState(() {
                bookAuthor = val;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hint: widget.book.description!,
            onChanged: (val) {
              setState(() {
                bookDescription = val;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hint: 'Tags: ' + widget.book.tags!.join(','),
            onChanged: (val) {
              setState(() {
                tags = val.trim().toLowerCase();
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hint: widget.book.retailType,
            onChanged: (val) {
              setState(() {
                retailType = val.trim().toLowerCase();
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hint: 'KES ' + widget.book.price!,
            onChanged: (val) {
              setState(() {
                bookPrice = val;
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 48,
            child: RaisedButton(
              child: isLoading ? const MyLoader() : const Text('Save  Changes'),
              color: kPrimaryColor,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                String url = '';
                try {
                  if (bookImage != null) {
                    final upload = await FirebaseStorage.instance
                        .ref('books/${user.userId}/${bookTitle!}/')
                        .putFile(bookImage!);

                    url = await upload.ref.getDownloadURL();
                  }
                  final book = BookModel(
                      author: bookAuthor ?? widget.book.author,
                      description: bookDescription ?? widget.book.description,
                      imgUrl: url.isEmpty ? widget.book.imgUrl : url,
                      ownerId: user.userId,
                      ownerName: user.fullName,
                      retailType: retailType ?? widget.book.retailType,
                      review: widget.book.review,
                      view: widget.book.view,
                      price: bookPrice ?? widget.book.price,
                      name: bookTitle ?? widget.book.name,
                      tags: tags == null ? widget.book.tags : tags!.split(','));
                  await Provider.of<BookProvider>(context, listen: false)
                      .updateBook(book, user);
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Book Added'),
                    ),
                  );
                  setState(() {
                    isLoading = false;
                  });
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  print(e);
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
