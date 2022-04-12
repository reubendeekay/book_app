import 'package:bookapp/constants.dart';
import 'package:bookapp/src/models/request_model.dart';
import 'package:bookapp/src/pages/home/widget/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class PurchaseDetailsScreen extends StatelessWidget {
  const PurchaseDetailsScreen({Key? key, required this.request})
      : super(key: key);
  final RequestModel request;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(children: [
            IgnorePointer(
              ignoring: true,
              child: BookTile(book: request.book!),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  buildDetail('Name', request.user!.fullName!),
                  buildDetail('Phone number', request.user!.phoneNumber!),
                  buildDetail('Mpesa number', request.phoneNumber!),
                  buildDetail('Address', request.address!),
                  buildDetail('Instructions', request.instructions!),
                ],
              ),
            ),
          ]),
          Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildEvelatedButton(Icons.sell, 'Confirm', Colors.green,
                      () async {
                    await FlutterPhoneDirectCaller.callNumber(
                        request.user!.phoneNumber!);
                  }),
                  _buildEvelatedButton(Icons.call, 'Call', kPrimaryColor, () {})
                ],
              ))
        ],
      ),
    );
  }

  Widget buildDetail(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Spacer(),
          Text(value)
        ],
      ),
    );
  }

  Widget _buildEvelatedButton(
          IconData icon, String text, Color color, Function action) =>
      SizedBox(
        height: 40,
        width: 150,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () => action(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
}
