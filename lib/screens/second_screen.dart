import 'package:flutter/material.dart';

import '../main.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return const Layout(
      children: [
        SimpleCalculator(),
      ],
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({super.key});

  @override
  SimpleCalculatorState createState() => SimpleCalculatorState();
}

class SimpleCalculatorState extends State<SimpleCalculator> {
  static const _clearBtn = 'Очистить';

  String output = '0';
  String _output = '0';
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = '';

  void buttonPressed(String buttonText) {
    if (buttonText == _clearBtn) {
      _output = '0';
      num1 = 0.0;
      num2 = 0.0;
      operand = '';
    } else if (buttonText == '+' ||
        buttonText == '-' ||
        buttonText == '/' ||
        buttonText == '*') {
      num1 = double.parse(output);
      operand = buttonText;
      _output = '0';
    } else if (buttonText == '.') {
      if (_output.contains('.')) {
        // Уже есть double
        return;
      } else {
        _output = _output + buttonText;
      }
    } else if (buttonText == '=') {
      num2 = double.parse(output);

      if (operand == '+') {
        _output = (num1 + num2).toString();
      }
      if (operand == '-') {
        _output = (num1 - num2).toString();
      }
      if (operand == '*') {
        _output = (num1 * num2).toString();
      }
      if (operand == '/') {
        _output = (num1 / num2).toString();
      }
      num1 = 0.0;
      num2 = 0.0;
      operand = '';
    } else {
      _output = _output + buttonText;
    }

    setState(() {
      output = double.parse(_output).toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
          child: Text(
            output,
            style: const TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(),
        Column(children: [
          Row(children: [
            Button('7', buttonPressed: buttonPressed),
            Button('8', buttonPressed: buttonPressed),
            Button('9', buttonPressed: buttonPressed),
            Button('/', buttonPressed: buttonPressed)
          ]),
          Row(children: [
            Button('4', buttonPressed: buttonPressed),
            Button('5', buttonPressed: buttonPressed),
            Button('6', buttonPressed: buttonPressed),
            Button('*', buttonPressed: buttonPressed)
          ]),
          Row(children: [
            Button('1', buttonPressed: buttonPressed),
            Button('2', buttonPressed: buttonPressed),
            Button('3', buttonPressed: buttonPressed),
            Button('-', buttonPressed: buttonPressed)
          ]),
          Row(children: [
            Button('.', buttonPressed: buttonPressed),
            Button('0', buttonPressed: buttonPressed),
            Button('00', buttonPressed: buttonPressed),
            Button('+', buttonPressed: buttonPressed)
          ]),
          Row(children: [
            Button(_clearBtn, buttonPressed: buttonPressed),
            Button('=', buttonPressed: buttonPressed),
          ])
        ])
      ],
    );
  }
}

class Button extends StatelessWidget {
  final String buttonText;
  final void Function(String) buttonPressed;

  const Button(
    this.buttonText, {
    super.key,
    required this.buttonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[300],
            onPrimary: Colors.white,
            padding: const EdgeInsets.all(16.0),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => buttonPressed(buttonText),
        ),
      ),
    );
  }
}
