import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AppText({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    const defaultStyle = TextStyle(
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500,
      fontSize: 16,
      
    );

    return Text(text, style: defaultStyle.merge(style));
  }
}
