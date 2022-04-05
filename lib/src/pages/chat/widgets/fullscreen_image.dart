import 'package:bookapp/screens/helpers/cached_image.dart';
import 'package:flutter/material.dart';

class FullscreenImage extends StatelessWidget {
  const FullscreenImage({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: cachedImage(
        image,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    ));
  }
}
