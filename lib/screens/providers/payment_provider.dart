import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PaymentProvider with ChangeNotifier {
  double _price = 0;
  double get price => _price;

  double _voucher = 0;
  double get voucher => _voucher;
  double _shipping = 0;
  double get shipping => _shipping;
  String _message = '';
  String get message => _message;
  bool isInit = false;

  void initiliasePrice(double initPrice) {
    _price = initPrice;
  }

  Future<void> validateVoucher(String enteredVoucher) async {
    final results = await FirebaseFirestore.instance
        .collection('services')
        .doc('promo')
        .collection('vouchers')
        .where('voucher', isEqualTo: enteredVoucher.toLowerCase())
        .get();

    _voucher = double.parse(results.docs.first['amount'].toString());
    _message = results.docs.first['voucher'].toUpperCase() +
        ' applied. Discount KES ' +
        voucher.toStringAsFixed(0);

    notifyListeners();
  }
}
