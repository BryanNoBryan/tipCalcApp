import 'package:flutter/material.dart';

class BestButton extends StatelessWidget {
  const BestButton(this.w, this.h, this.text, this.callback, {super.key});

  final double w, h;
  final String text;
  final Function callback;

  final double margin = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110 * w + (w == 1 ? 0 : margin * w),
      height: 70 * h,
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 58, 58, 58),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () => callback(text),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
