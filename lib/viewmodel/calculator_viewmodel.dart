import 'package:flutter/foundation.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator/utils/database_helper.dart';
import 'package:calculator/model/calculation_history.dart';

class CalculatorViewModel extends ChangeNotifier {
  String _display = '0';
  String _expression = ''; 
  bool _isDarkMode = true;
  int _openBrackets = 0;
  
  List<CalculationHistory> _historyList = [];
  
  bool _justCalculated = false;

  String get display => _display;
  String get expression => _expression;
  bool get isDarkMode => _isDarkMode;
  List<CalculationHistory> get history => _historyList;

  Future<void> loadHistory() async {
    _historyList = await DatabaseHelper.instance.getAllHistory();
  }

  Future<void> clearHistory() async {
    await DatabaseHelper.instance.clearHistory();
    await loadHistory();
    notifyListeners();
  }

  CalculatorViewModel() {
    loadHistory().then((_) {
      notifyListeners();
    });
  }

  void onButtonPressed(String text) async {
    if (text == 'C') {
      _clear();
    } else if (text == '=') {
      await _calculate(); 
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

  void useHistoryValue(CalculationHistory historyEntry) {
    final result = historyEntry.result;
    _justCalculated = false;

    if (_display == '0' || _display == 'Error' || _justCalculated) {
      _display = result;
    } else {
      _display += result;
    }
    notifyListeners();
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _openBrackets = 0;
    _justCalculated = false;
  }
  
  void _handleNumber(String number) {
    if (_display == '0' || _justCalculated) {
      _display = number;
      _justCalculated = false;
    } else {
      _display += number;
    }
  }

  void _handleDecimal() {
    if (_justCalculated) {
      _display = '0.';
      _justCalculated = false;
    } else if (!_display.contains('.')) {
      _display += '.';
    }
  }

  void _handleOperator(String op) {
    _justCalculated = false;
    
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
    _justCalculated = false;
    
    String lastChar = _display.substring(_display.length - 1);
    if (_display == '0' || _justCalculated) {
      _display = '(';
      _openBrackets++;
      _justCalculated = false;
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

  Future<void> _calculate() async {
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
      
      String resultString;
      if (eval == eval.toInt()) {
        resultString = eval.toInt().toString();
      } else {
        resultString = eval.toStringAsFixed(2);
      }
      
      _display = resultString;

      final newHistory = CalculationHistory(
        expression: _expression,
        result: resultString,
        timestamp: DateTime.now(),
      );
      await DatabaseHelper.instance.insert(newHistory);
      
      await loadHistory();

    } catch (e) {
      _expression = _display; 
      _display = 'Error'; 
    }
    
    _justCalculated = true;
  }
}