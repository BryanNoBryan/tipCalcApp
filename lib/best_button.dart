import 'package:flutter/material.dart';

class BestButton extends StatelessWidget {
  const BestButton(
      this.w, this.h, this.text, this.callback, this.boxColor, this.textColor,
      {super.key});

  final double w, h;
  final String text;
  final Function callback;
  final Color boxColor, textColor;

  final double margin = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110 * w + (w == 1 ? 0 : margin * w),
      height: 70 * h,
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () => callback(text),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
