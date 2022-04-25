import 'package:bookapp/constants.dart';
import 'package:bookapp/screens/helpers/calendar_popup.dart';
import 'package:bookapp/screens/helpers/lipa_na_mpesa.dart';
import 'package:bookapp/screens/helpers/my_loader.dart';
import 'package:bookapp/screens/providers/auth_provider.dart';
import 'package:bookapp/src/models/book_model.dart';
import 'package:bookapp/src/models/request_model.dart';
import 'package:bookapp/src/pages/add_book/widgets/my_text_field.dart';
import 'package:bookapp/src/pages/detail/thank_you_screen.dart';
import 'package:bookapp/src/pages/home/widget/book_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            widget.book.retailType == 'buy' ? 'Purchase Book' : 'Borrow Book'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: size.height - kToolbarHeight - 290,
            child: Column(
              children: [
                BookTile(book: widget.book),
                if (widget.book.retailType == 'borrow')
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => CalendarPopupView(
                                    initialStartDate: startDate,
                                    initialEndDate: startDate,
                                    onApplyClick: (val1, val2) {
                                      setState(() {
                                        startDate = val1;
                                        endDate = val2;
                                      });
                                    },
                                  ));
                        },
                        child: Row(
                          children: const [
                            Text(
                              'Select Borrow time',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.date_range)
                          ],
                        ),
                      )),
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
                ),
              ],
            ),
          ),
          Container(
            height: 230,
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                        style: TextStyle(fontSize: 12, color: kPrimaryColor),
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
                  onPressed: phoneNumber == null || address == null
                      ? null
                      : () async {
                          final request = RequestModel(
                            book: widget.book,
                            phoneNumber: phoneNumber,
                            user: user,
                            address: address,
                            instructions: instructions ?? '',
                            purchasedAt: Timestamp.now(),
                          );

                          setState(() {
                            isLoading = true;
                          });

                          String getPhone() {
                            if (phoneNumber!.length > 10) {
                              return phoneNumber!;
                            }
                            return phoneNumber!.replaceRange(0, 1, '254');
                          }

                          try {
                            await depositMpesa(
                              amount: widget.book.price!,
                              phoneNumber: getPhone(),
                            ).then((value) => Get.off(() => ThankYouPage(
                                  request: request,
                                )));
                            // Get.off(ThankYouPage(request: request));
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
          )
        ],
      ),
    );
  }
}
