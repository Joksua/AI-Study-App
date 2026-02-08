import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _currentNumber = '';
  String _previousNumber = '';
  String _operation = '';
  bool _shouldResetDisplay = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _clear();
      } else if (value == '⌫') {
        _backspace();
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        _setOperation(value);
      } else if (value == '=') {
        _calculate();
      } else if (value == '.') {
        _addDecimal();
      } else {
        _addNumber(value);
      }
    });
  }

  void _clear() {
    _display = '0';
    _currentNumber = '';
    _previousNumber = '';
    _operation = '';
    _shouldResetDisplay = false;
  }

  void _backspace() {
    if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
      _currentNumber = _display;
    } else {
      _display = '0';
      _currentNumber = '';
    }
  }

  void _addNumber(String number) {
    if (_shouldResetDisplay) {
      _display = number;
      _currentNumber = number;
      _shouldResetDisplay = false;
    } else {
      if (_display == '0') {
        _display = number;
      } else {
        _display += number;
      }
      _currentNumber = _display;
    }
  }

  void _addDecimal() {
    if (_shouldResetDisplay) {
      _display = '0.';
      _currentNumber = '0.';
      _shouldResetDisplay = false;
    } else if (!_display.contains('.')) {
      _display += '.';
      _currentNumber = _display;
    }
  }

  void _setOperation(String op) {
    if (_currentNumber.isNotEmpty) {
      if (_previousNumber.isNotEmpty && _operation.isNotEmpty) {
        _calculate();
      }
      _previousNumber = _currentNumber;
      _operation = op;
      _shouldResetDisplay = true;
    }
  }

  void _calculate() {
    if (_previousNumber.isEmpty || _currentNumber.isEmpty || _operation.isEmpty) {
      return;
    }

    double num1 = double.parse(_previousNumber);
    double num2 = double.parse(_currentNumber);
    double result = 0;

    switch (_operation) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '×':
        result = num1 * num2;
        break;
      case '÷':
        if (num2 != 0) {
          result = num1 / num2;
        } else {
          _display = 'Error';
          _clear();
          return;
        }
        break;
    }

    // Format result to remove unnecessary decimals
    if (result == result.toInt()) {
      _display = result.toInt().toString();
    } else {
      _display = result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
    }

    _currentNumber = _display;
    _previousNumber = '';
    _operation = '';
    _shouldResetDisplay = true;
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            foregroundColor: textColor ?? Colors.black,
            padding: const EdgeInsets.all(24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Display
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Buttons
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('C', color: Colors.red[400], textColor: Colors.white),
                        _buildButton('⌫', color: Colors.orange[400], textColor: Colors.white),
                        _buildButton('÷', color: Colors.blue[400], textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton('×', color: Colors.blue[400], textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton('-', color: Colors.blue[400], textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton('+', color: Colors.blue[400], textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('0'),
                        _buildButton('.'),
                        _buildButton('=', color: Colors.green[400], textColor: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

