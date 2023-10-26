import 'package:calculator/BestButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //to prevent textField overflow
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black54,
      appBar: makeAppBar(),
      body: makeBody(),
    );
  }

  Color grey = Colors.white38;
  Color black = Colors.black;

  String historyText = '';
  String hintText = 'Enter the Total Cost: ';
  String hintTextEnterTotalCost = 'Enter the Total Cost: ';
  String hintTextEnterCustomTip = 'Enter Tip%: ';
  double totalCost = 0;
  bool isCustomTip = false;
  Color inputOutlineColor = Colors.black;
  Icon? suffixIcon; //percent
  var input = TextEditingController();
  var scrollController = ScrollController();

  void buttonPressed(String str) {
    bool isNumeric(String s) {
      return double.tryParse(s) != null;
    }

    setState(() {
      if (!isNumeric(input.text) && !isCustomTip) {
        inputOutlineColor = Colors.red;
        return;
      } else {
        inputOutlineColor = Colors.black;
      }

      printPresets(double x) {
        historyText += '\n-------------\n${input.text}';
        historyText +=
            '\ntip: ${(double.parse(input.text) * x).toStringAsFixed(2)}';
        input.text = '';
        //for some reason, the jump to maxScrollExtent doesn't work, but
        //changing to min and changing the direction of the scroller to reverse fixed it
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      }

      if (str == '12%') {
        printPresets(0.12);
      } else if (str == '15%') {
        printPresets(0.15);
      } else if (str == '18%') {
        printPresets(0.18);
      } else if (str == 'Custom') {
        totalCost = double.parse(input.text);
        isCustomTip = true;
        input.text = '';
        suffixIcon = const Icon(Icons.percent_outlined);
        hintText = hintTextEnterCustomTip;
      } else if (isNumeric(str)) {
        input.text += str;
      } else if (str == '=') {
        historyText += '\n-------------\n${totalCost.toString()}';
        historyText +=
            '\ntip: ${(totalCost * double.parse(input.text) / 100).toStringAsFixed(2)}';
        input.text = '';
        suffixIcon = null;
        isCustomTip = false;
        hintText = hintTextEnterTotalCost;
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      } else if (str == '⌫') {
        if (input.text.isNotEmpty) {
          input.text = input.text.substring(0, input.text.length - 1);
        }
      }
    });
  }

  AppBar makeAppBar() {
    return AppBar(
      toolbarHeight: 100,
      leadingWidth: 80,
      elevation: 0,
      backgroundColor: Colors.black,
      leading: GestureDetector(
        onTap: () => setState(() {
          historyText = 'lol does nothing.';
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
              'TactileTips',
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
        color: black,
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              alignment: Alignment.bottomRight,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.all(5),
              child: Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  child: Text(
                    historyText,
                    style: const TextStyle(color: Colors.white, fontSize: 40),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
              ),
              height: 70,
              child: TextField(
                onChanged: (change) => buttonPressed('TEXTCHANGED'),
                keyboardType: TextInputType.number,
                controller: input,
                style: const TextStyle(
                    fontSize: 30.0, height: 1.0, color: Colors.black),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(15),
                    hintText: hintText,
                    prefixIcon: const Icon(Icons.attach_money_outlined),
                    suffixIcon: suffixIcon,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: inputOutlineColor, width: 4.0),
                    )),
              ),
            ),
            isCustomTip ? customTip() : tipChoices(),
          ],
        ),
      ),
    );
  }

  Column tipChoices() {
    return Column(
      children: [
        BestButton(3, 1, '12%', buttonPressed),
        BestButton(3, 1, '15%', buttonPressed),
        BestButton(3, 1, '18%', buttonPressed),
        BestButton(3, 1, 'Custom', buttonPressed),
      ],
    );
  }

  Column customTip() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BestButton(1, 1, '7', buttonPressed),
            BestButton(1, 1, '8', buttonPressed),
            BestButton(1, 1, '9', buttonPressed),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BestButton(1, 1, '4', buttonPressed),
            BestButton(1, 1, '5', buttonPressed),
            BestButton(1, 1, '6', buttonPressed),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BestButton(1, 1, '1', buttonPressed),
            BestButton(1, 1, '2', buttonPressed),
            BestButton(1, 1, '3', buttonPressed),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BestButton(1, 1, '⌫', buttonPressed),
            BestButton(1, 1, '0', buttonPressed),
            BestButton(1, 1, '=', buttonPressed),
          ],
        ),
      ],
    );
  }
}
