import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/button_builder.dart';
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _currentInput = '';
  String _history = '';
  List<String> _calculationParts = [];

  void _calculateResult() {
    if (_calculationParts.isEmpty && _currentInput.isEmpty) return;

    if (_currentInput.isNotEmpty) {
      _calculationParts.add(_currentInput);
    }

    if (_calculationParts.length < 3) {
      return;
    }

    double result = 0.0;
    try {
      result = double.parse(_calculationParts[0]);

      for (int i = 1; i < _calculationParts.length; i += 2) {
        String operator = _calculationParts[i];
        double nextNumber = double.parse(_calculationParts[i + 1]);

        switch (operator) {
          case '+':
            result += nextNumber;
            break;
          case '-':
            result -= nextNumber;
            break;
          case 'x':
            result *= nextNumber;
            break;
          case '÷':
            if (nextNumber == 0) {
              _currentInput = 'Error: Div by zero';
              _history = '';
              _calculationParts.clear();
              return;
            }
            result /= nextNumber;
            break;
          case '%':
            result %= nextNumber;
            break;
        }
      }
      _currentInput = _formatResult(result);
      _history = _calculationParts.join('');
      _calculationParts.clear();
    } catch (e) {
      _currentInput = 'Error';
      _history = '';
      _calculationParts.clear();
    }
  }

  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toStringAsFixed(5);
    }
  }

  void btnClick(String value) {
    setState(() {
      if (value == 'C') {
        _currentInput = '';
        _history = '';
        _calculationParts.clear();
      } else if (value == '+' ||
          value == '-' ||
          value == 'x' ||
          value == '÷' ||
          value == '%') {
        if (_currentInput.isNotEmpty) {
          _calculationParts.add(_currentInput);
          _calculationParts.add(value);
          _history = _calculationParts.join('');
          _currentInput = '';
        } else if (_calculationParts.isNotEmpty &&
            _calculationParts.last.isNotEmpty &&
            (_calculationParts.last == '+' ||
                _calculationParts.last == '-' ||
                _calculationParts.last == 'x' ||
                _calculationParts.last == '÷' ||
                _calculationParts.last == '%')) {
          _calculationParts[_calculationParts.length - 1] = value;
          _history = _calculationParts.join('');
        }
      } else if (value == '=') {
        _calculateResult();
      } else if (value == '<') {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
        } else if (_calculationParts.isNotEmpty) {
          _calculationParts.removeLast();
          if (_calculationParts.isNotEmpty &&
              (_calculationParts.last != '+' &&
                  _calculationParts.last != '-' &&
                  _calculationParts.last != 'x' &&
                  _calculationParts.last != '÷' &&
                  _calculationParts.last != '%')) {
            _currentInput = _calculationParts.removeLast();
          }
          _history = _calculationParts.join('');
        }
      } else if (value == '√') {
        if (_currentInput.isNotEmpty) {
          try {
            double number = double.parse(_currentInput);
            if (number < 0) {
              _currentInput = 'Error: Negative root';
              _history = '';
            } else {
              _currentInput = _formatResult(sqrt(number));
              _history = 'sqrt($_history)';
            }
          } catch (e) {
            _currentInput = 'Error';
          }
        }
      } else {
        if (value == '.' && _currentInput.contains('.')) {
          return;
        }
        _currentInput += value;
      }
      if (value != '=' &&
          value != 'C' &&
          value != '<' &&
          value != '√' &&
          !(_calculationParts.isNotEmpty &&
              _calculationParts.last.isNotEmpty &&
              (_calculationParts.last == '+' ||
                  _calculationParts.last == '-' ||
                  _calculationParts.last == 'x' ||
                  _calculationParts.last == '÷' ||
                  _calculationParts.last == '%'))) {
        _history = _calculationParts.join('') + _currentInput;
      }
    });
  }

  double sqrt(double x) {
    return x == 0
        ? 0
        : (x / sqrt(x / 2 + 1) + sqrt(x / 2 + 1)) /
              2;
  }

  @override
  void initState() {
    super.initState();
    _currentInput = '';
    _history = '';
    _calculationParts = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  _history.isEmpty ? '0' : _history,
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(fontSize: 24, color: Colors.white38),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  _currentInput.isEmpty ? '0' : _currentInput,
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                ButtonBuilder(
                  text: 'C',
                  color: Color(0xFF4e4f61),
                  callback: btnClick,
                ),
                ButtonBuilder(
                  text: '√',
                  color: Color(0xFF4e4f61),
                  callback: btnClick,
                ),
                ButtonBuilder(
                  text: '%',
                  color: Color(0xFF4e4f61),
                  callback: btnClick,
                ),
                ButtonBuilder(
                  text: '÷',
                  color: Color(0xFF4a5dfe),
                  callback: btnClick,
                ),
              ],
            ),
            Row(
              children: [
                ButtonBuilder(text: '7', callback: btnClick),
                ButtonBuilder(text: '8', callback: btnClick),
                ButtonBuilder(text: '9', callback: btnClick),
                ButtonBuilder(
                  text: 'x',
                  color: Color(0xFF4a5dfe),
                  callback: btnClick,
                ),
              ],
            ),
            Row(
              children: [
                ButtonBuilder(text: '4', callback: btnClick),
                ButtonBuilder(text: '5', callback: btnClick),
                ButtonBuilder(text: '6', callback: btnClick),
                ButtonBuilder(
                  text: '-',
                  color: Color(0xFF4a5dfe),
                  callback: btnClick,
                ),
              ],
            ),
            Row(
              children: [
                ButtonBuilder(text: '1', callback: btnClick),
                ButtonBuilder(text: '2', callback: btnClick),
                ButtonBuilder(text: '3', callback: btnClick),
                ButtonBuilder(
                  text: '+',
                  color: Color(0xFF4a5dfe),
                  callback: btnClick,
                ),
              ],
            ),
            Row(
              children: [
                ButtonBuilder(text: '.', callback: btnClick),
                ButtonBuilder(text: '0', callback: btnClick),
                ButtonBuilder(text: '<', callback: btnClick),
                ButtonBuilder(
                  text: '=',
                  color: Color(0xFF4a5dfe),
                  callback: btnClick,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
