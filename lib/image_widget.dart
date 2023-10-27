import 'package:flutter/material.dart';

class MyImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/wiki.jpg',
      width: 700,
      height: 500,
    );
  }
}
