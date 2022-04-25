import 'package:bookapp/constants.dart';
import 'package:bookapp/invoice/widgets/title_widget.dart';
import 'package:bookapp/screens/auth/widgets/button_widget.dart';
import 'package:bookapp/screens/providers/invoice_provider.dart';
import 'package:bookapp/src/models/invoice_models.dart';
import 'package:flutter/material.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('My Invoice'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const TitleWidget(
                  icon: Icons.picture_as_pdf,
                  text: 'Generate Invoice',
                ),
                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'Invoice PDF',
                  backColor: [kPrimaryColor],
                  textColor: [Colors.white],
                  onPressed: () async {
                    final date = DateTime.now();
                    final dueDate = date.add(const Duration(days: 7));

                    final invoice = Invoice(
                      supplier: const Supplier(
                        name: 'Best Mechanic',
                        address: 'CBD, Nairobi, Kenya',
                        paymentInfo: 'https://paypal.me/bestmechanic',
                      ),
                      customer: const Customer(
                        name: 'Reuben Jefwa.',
                        address: 'Kilimani, Nairobi, Kenya',
                      ),
                      info: InvoiceInfo(
                        date: date,
                        dueDate: dueDate,
                        description: 'My description...',
                        number: '${DateTime.now().year}-9999',
                      ),
                      items: [
                        InvoiceItem(
                          description: 'Car Wash',
                          date: DateTime.now(),
                          quantity: 1,
                          vat: 0.19,
                          unitPrice: 5.99,
                        ),
                        InvoiceItem(
                          description: 'Tire Change',
                          date: DateTime.now(),
                          quantity: 1,
                          vat: 0.19,
                          unitPrice: 40.99,
                        ),
                        InvoiceItem(
                          description: 'General service',
                          date: DateTime.now(),
                          quantity: 1,
                          vat: 0.19,
                          unitPrice: 100.99,
                        ),
                        InvoiceItem(
                          description: 'Consultation',
                          date: DateTime.now(),
                          quantity: 1,
                          vat: 0.19,
                          unitPrice: 3.99,
                        ),
                        InvoiceItem(
                          description: 'Wheel alignment',
                          date: DateTime.now(),
                          quantity: 1,
                          vat: 0.19,
                          unitPrice: 11.59,
                        ),
                      ],
                    );

                    final pdfFile = await PdfInvoiceApi.generate(invoice);

                    PdfApi.openFile(pdfFile);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}

final date = DateTime.now();
final dueDate = date.add(const Duration(days: 7));

final invoice = Invoice(
  supplier: const Supplier(
    name: 'Best Mechanic',
    address: 'CBD, Nairobi, Kenya',
    paymentInfo: 'https://paypal.me/bestmechanic',
  ),
  customer: const Customer(
    name: 'Reuben Jefwa.',
    address: 'Kilimani, Nairobi, Kenya',
  ),
  info: InvoiceInfo(
    date: date,
    dueDate: dueDate,
    description: 'My description...',
    number: '${DateTime.now().year}-9999',
  ),
  items: [
    InvoiceItem(
      description: 'Car Wash',
      date: DateTime.now(),
      quantity: 1,
      vat: 0.19,
      unitPrice: 5.99,
    ),
    InvoiceItem(
      description: 'Tire Change',
      date: DateTime.now(),
      quantity: 1,
      vat: 0.19,
      unitPrice: 40.99,
    ),
    InvoiceItem(
      description: 'General service',
      date: DateTime.now(),
      quantity: 1,
      vat: 0.19,
      unitPrice: 100.99,
    ),
    InvoiceItem(
      description: 'Consultation',
      date: DateTime.now(),
      quantity: 1,
      vat: 0.19,
      unitPrice: 3.99,
    ),
    InvoiceItem(
      description: 'Wheel alignment',
      date: DateTime.now(),
      quantity: 1,
      vat: 0.19,
      unitPrice: 11.59,
    ),
  ],
);
