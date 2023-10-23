import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: makeAppBar(),
      body: makeBody(),
    );
  }

  String expression = '0';

  void buttonPressed(String str) {
    String removeDecimalIfCan(dynamic result) {
      if (result.toString().contains('.')) {
        List<String> splitDecimal = result.toString().split('.');
        if (!(int.parse(splitDecimal[1]) > 0)) {
          return result = splitDecimal[0].toString();
        }
      }
      return result;
    }

    bool isNumeric(String s) {
      return double.tryParse(s) != null;
    }

    //EM DASH FOR MINUS SIGN, - for negative

    setState(() {
      if (str == 'AC') {
        expression = '0';
      } else if (str == '+/-' && expression[0] != '0') {
        List<String> splitNums = expression.split(RegExp(r"[+—×÷]"));
        if (splitNums.isNotEmpty) {
          String newString = splitNums[splitNums.length - 1];
          int len = newString.length;
          newString = newString[0] == '-'
              ? newString.substring(1, newString.length)
              : '-$newString';

          expression =
              expression.substring(0, expression.length - len) + newString;
        }
      } else if (str == '⌫') {
        if (expression.length == 1) {
          expression = '0';
        } else if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else if (str == '÷') {
        expression += '÷';
      } else if (str == '×') {
        expression += '×';
      } else if (str == '—') {
        expression += '—';
      } else if (str == '+') {
        expression += '+';
      } else if (str == '.') {
        expression += '.';
      } else if (isNumeric(str)) {
        expression += str;
      } else if (str == '=') {
        expression = expression.replaceAll('—', '-');
        expression = expression.replaceAll('÷', '/');
        expression = expression.replaceAll('×', '*');

        Expression exp = Parser().parse(expression);
        double eval = exp.evaluate(EvaluationType.REAL, ContextModel());
        expression = removeDecimalIfCan(eval.toString());
      }
      if (expression.length == 2 &&
          expression[0] == '0' &&
          expression[1] != '.') {
        expression = expression[1];
      }
    });
  }

  AppBar makeAppBar() {
    return AppBar(
      toolbarHeight: 100,
      leadingWidth: 80,
      elevation: 0,
      backgroundColor: Colors.black54,
      leading: GestureDetector(
        onTap: () => setState(() {
          expression = 'lol does nothing.';
        }),
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 212, 252, 255),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'images/left_arrow.svg',
            height: 30,
            width: 30,
          ),
        ),
      ),
      actions: const [
        Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'SimpliCalc',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  SafeArea makeBody() {
    return SafeArea(
      child: Container(
        color: Colors.lightBlue,
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5),
              child: Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    expression,
                    style: const TextStyle(color: Colors.black, fontSize: 40),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BestButton(1, 1, 'AC', buttonPressed),
                BestButton(1, 1, '+/-', buttonPressed),
                BestButton(1, 1, '⌫', buttonPressed),
                BestButton(1, 1, '÷', buttonPressed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BestButton(1, 1, '7', buttonPressed),
                BestButton(1, 1, '8', buttonPressed),
                BestButton(1, 1, '9', buttonPressed),
                BestButton(1, 1, '×', buttonPressed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BestButton(1, 1, '4', buttonPressed),
                BestButton(1, 1, '5', buttonPressed),
                BestButton(1, 1, '6', buttonPressed),
                BestButton(1, 1, '—', buttonPressed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BestButton(1, 1, '1', buttonPressed),
                BestButton(1, 1, '2', buttonPressed),
                BestButton(1, 1, '3', buttonPressed),
                BestButton(1, 1, '+', buttonPressed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BestButton(2, 1, '0', buttonPressed),
                BestButton(1, 1, '.', buttonPressed),
                BestButton(1, 1, '=', buttonPressed),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BestButton extends StatelessWidget {
  const BestButton(this.w, this.h, this.text, this.callback, {super.key});

  final double w, h;
  final String text;
  final Function callback;

  final double margin = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70 * w + (w == 1 ? 0 : margin * w),
      height: 70 * h,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: Colors.black,
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
