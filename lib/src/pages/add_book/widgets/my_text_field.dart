import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({Key? key, this.hint, this.onChanged}) : super(key: key);

  final String? hint;
  final Function(String value)? onChanged;

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: null,
      maxLines: null,
      onChanged: (val) {
        setState(() {
          widget.onChanged!(val);
        });
      },
      validator: (val) {
        if (val!.isEmpty) {
          return 'Enter the ${widget.hint!}';
        }
        return null;
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: widget.hint,
          border: InputBorder.none,
          fillColor: Theme.of(context).cardColor,
          filled: true),
    );
  }
}
