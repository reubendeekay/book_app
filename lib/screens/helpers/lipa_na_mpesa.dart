import 'package:flutter/material.dart';
import 'package:mpesa/mpesa.dart';

Mpesa mpesa = Mpesa(
  clientKey: "sWuAK847VPnXJLdxlyGuFzWlL1AIhoGW",
  clientSecret: "0suB4AxiNV8hGVqX",
  passKey:
      "53beb23ef8b57ee44ef9b74349847a2909bbc169227e434067f36a711f2681a9".trim(),
  environment: "production",
);

Future<void> depositMpesa({
  String? phoneNumber,
  String? amount,
}) async {
  mpesa
      .lipaNaMpesa(
        phoneNumber: phoneNumber!,
        amount: double.parse(amount!),
        businessShortCode: "4086809",
        accountReference: phoneNumber.replaceRange(0, 1, ''),
        callbackUrl: 'https://facebook.com',
      )
      .then((result) async {})
      .catchError((error) {
    print('ERROR : ' + error.toString());
  });
}
