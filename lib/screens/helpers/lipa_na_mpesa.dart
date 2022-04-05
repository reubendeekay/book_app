import 'package:flutter/material.dart';
import 'package:mpesa/mpesa.dart';

Mpesa mpesa = Mpesa(
  clientKey: "w0sP3rGGfdTVDcpuAk4ADect3pFARVNU",
  clientSecret: "6hPJz5IEtxfv1X4E",
  passKey:
      "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919".trim(),
  environment: "sandbox",
);

Future<void> depositMpesa({
  String? phoneNumber,
  String? amount,
}) async {
  mpesa
      .lipaNaMpesa(
        phoneNumber: phoneNumber!,
        amount: double.parse(amount!),
        businessShortCode: "174379",
        accountReference: phoneNumber.replaceRange(0, 1, ''),
        callbackUrl: '',
      )
      .then((result) async {})
      .catchError((error) {
    print('ERROR : ' + error.toString());
  });
}
