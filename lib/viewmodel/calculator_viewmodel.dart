import 'package:flutter/foundation.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorViewModel extends ChangeNotifier {
  String _display = '0';
  
  String _expression = ''; 
  
  bool _isDarkMode = true;
  final List<String> _history = [];
  
  int _openBrackets = 0;

  String get display => _display;
  String get expression => _expression;
  bool get isDarkMode => _isDarkMode;
  List<String> get history => _history;

  void onButtonPressed(String text) {
    if (text == 'C') {
      _clear();
    } else if (text == '=') {
      _calculate();
    } else if (text == '()') {
      _handleBrackets();
    } else if (text == '÷' || text == '×' || text == '-' || text == '+') {
      _handleOperator(text);
    } else if (text == '%') {
      _handleOperator('%');
    } else if (text == '.') {
      _handleDecimal();
    }
    else {
      _handleNumber(text);
    }
    
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void useHistoryValue(String historyEntry) {
    String result = historyEntry.split(' = ').last;

    if (double.tryParse(result) != null) {
      if (_display == '0' || _display == 'Error') {
        _display = result;
      } else {
        _display += result;
      }
      
      notifyListeners();
    }
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _openBrackets = 0;
  }

  void _handleNumber(String number) {
    if (_display == '0') {
      _display = number;
    } else {
      _display += number;
    }
  }

  void _handleDecimal() {
    if (!_display.contains('.')) {
      _display += '.';
    }
  }

  void _handleOperator(String op) {
    if (_display == '0' && op != '-') {
      return;
    }

    String lastChar = _display.substring(_display.length - 1);
    if (lastChar == '÷' || lastChar == '×' || lastChar == '-' || lastChar == '+') {
      _display = _display.substring(0, _display.length - 1) + op;
    } else {
      _display += op;
    }
  }

  void _handleBrackets() {
    String lastChar = _display.substring(_display.length - 1);

    if (_display == '0') {
      _display = '(';
      _openBrackets++;
    } else if (lastChar == '÷' || lastChar == '×' || lastChar == '-' || lastChar == '+' || lastChar == '(') {
      _display += '(';
      _openBrackets++;
    } else if (_openBrackets > 0) {
      _display += ')';
      _openBrackets--;
    } else {
      _display += '×(';
      _openBrackets++;
    }
  }

  void _backspace() {
    if (_display == '0' || _display.isEmpty) {
      return;
    }
    if (_display.length == 1) {
      _display = '0';
      return;
    }
    
    String lastChar = _display.substring(_display.length - 1);
    if (lastChar == '(') {
      _openBrackets--;
    } else if (lastChar == ')') {
      _openBrackets++;
    }
    
    _display = _display.substring(0, _display.length - 1);
  }

  void _calculate() {
    String evalExpression = _display;

    evalExpression = evalExpression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('%', '/100');

    if (_openBrackets > 0) {
      evalExpression += ')' * _openBrackets;
      _openBrackets = 0;
    }

    try {
      Parser p = Parser();
      Expression exp = p.parse(evalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      _expression = _display; 

      if (eval == eval.toInt()) {
        _display = eval.toInt().toString();
      } else {
        _display = eval.toStringAsFixed(2);
      }

      _history.insert(0, '$evalExpression = $_display');

    } catch (e) {
      _expression = _display;
      _display = 'Error';
    }
  }
}