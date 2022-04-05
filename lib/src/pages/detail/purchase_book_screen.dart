import 'package:bookapp/constants.dart';
import 'package:bookapp/screens/helpers/lipa_na_mpesa.dart';
import 'package:bookapp/screens/helpers/my_loader.dart';
import 'package:bookapp/screens/providers/auth_provider.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/pages/add_book/widgets/my_text_field.dart';
import 'package:bookapp/src/pages/detail/thank_you_screen.dart';
import 'package:bookapp/src/pages/home/widget/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class PurchaseBookScreen extends StatefulWidget {
  const PurchaseBookScreen({Key? key, required this.book}) : super(key: key);
  final BookModel book;

  @override
  State<PurchaseBookScreen> createState() => _PurchaseBookScreenState();
}

class _PurchaseBookScreenState extends State<PurchaseBookScreen> {
  String? phoneNumber, address, instructions;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.book.retailType == 'buy'
              ? 'Purchase Book'
              : 'Borrow Book'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                BookTile(book: widget.book),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: MyTextField(
                    hint: 'Mpesa phone number',
                    onChanged: (val) {
                      setState(() {
                        phoneNumber = val;
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: MyTextField(
                    hint: 'Address',
                    onChanged: (val) {
                      setState(() {
                        address = val;
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: MyTextField(
                    hint: '(Optional) Special instructions',
                    onChanged: (val) {
                      setState(() {
                        instructions = val;
                      });
                    },
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    color: Theme.of(context).cardColor),
                child: Column(children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        const Text(
                          'Amount',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Text(
                          'KES ' + widget.book.price.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Text('Payment Method'),
                      const Spacer(),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.2),
                          ),
                          child: const Text(
                            'Mpesa',
                            style:
                                TextStyle(fontSize: 12, color: kPrimaryColor),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await depositMpesa(
                            amount: widget.book.price!,
                            phoneNumber: phoneNumber,
                          ).then(
                              (value) => Get.off(() => const ThankYouPage()));
                        } catch (e) {
                          print(e);

                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      color: kPrimaryColor,
                      child: isLoading ? const MyLoader() : const Text('Pay'),
                    ),
                  )
                ]),
              ),
            )
          ],
        ));
  }
}
