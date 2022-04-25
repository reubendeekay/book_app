import 'dart:io';

import 'package:bookapp/constants.dart';
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

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  String? bookTitle, bookAuthor, bookDescription, bookPrice, retailType, tags;
  File? bookImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Book'),
        elevation: 0,
        backgroundColor: Colors.transparent,
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
                    ? const Center(child: Text('No Image Selected'))
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
            hint: 'Book Title',
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
            hint: 'Book Author',
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
            hint: 'Book Description',
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
            hint: 'Tags(separate by commas)',
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
            hint: 'Buy or Borrow',
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
            hint: 'Book Price',
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
              child: isLoading ? const MyLoader() : const Text('Add Book'),
              color: kPrimaryColor,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                if (bookTitle == null ||
                    bookAuthor == null ||
                    bookDescription == null ||
                    tags == null ||
                    retailType == null ||
                    bookPrice == null ||
                    bookImage == null) {
                  setState(() {
                    isLoading = false;
                  });
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please fill all the fields'),
                      actions: [
                        FlatButton(
                          child: const Text('Ok'),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                  );
                  return;
                }
                try {
                  final upload = await FirebaseStorage.instance
                      .ref('books/${user.userId}/${bookTitle!}/')
                      .putFile(bookImage!);

                  final url = await upload.ref.getDownloadURL();
                  final book = BookModel(
                      author: bookAuthor,
                      description: bookDescription,
                      imgUrl: url,
                      ownerId: user.userId,
                      ownerName: user.fullName,
                      retailType: retailType,
                      review: '0',
                      view: 0,
                      price: bookPrice,
                      name: bookTitle,
                      tags: tags!.split(','));
                  await Provider.of<BookProvider>(context, listen: false)
                      .addBook(book, user);
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
