// viewmodel/calculator_viewmodel.dart
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
    // Hapus notifyListeners() dari sini untuk menghindari panggilan ganda
  }

  Future<void> clearHistory() async {
    await DatabaseHelper.instance.clearHistory();
    await loadHistory();
    notifyListeners(); // Panggil notifikasi setelah selesai
  }

  CalculatorViewModel() {
    // Muat riwayat saat aplikasi pertama kali dimulai
    loadHistory().then((_) {
      notifyListeners();
    });
  }

  // 1. Ubah fungsi ini menjadi ASYNC
  void onButtonPressed(String text) async {
    if (text == 'C') {
      _clear();
    } else if (text == '=') {
      // 2. TUNGGU (await) kalkulasi selesai
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
    
    // 3. Panggil notifyListeners() SATU KALI di akhir
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void useHistoryValue(CalculationHistory historyEntry) {
    final result = historyEntry.result;
    _justCalculated = false; // Reset flag saat pakai riwayat

    if (_display == '0' || _display == 'Error') {
      _display = result;
    } else {
      _display += result;
    }
    // notifyListeners() akan dipanggil oleh onButtonPressed
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _openBrackets = 0;
    _justCalculated = false; // Reset flag
  }
  
  void _handleNumber(String number) {
    // Logika yang sudah benar: jika baru saja menghitung, ganti display
    if (_display == '0' || _justCalculated) {
      _display = number;
      _justCalculated = false; // Langsung reset flag
    } else {
      _display += number;
    }
  }

  void _handleDecimal() {
    // Jika baru saja menghitung, mulai dengan "0."
    if (_justCalculated) {
      _display = '0.';
      _justCalculated = false;
    } else if (!_display.contains('.')) {
      _display += '.';
    }
  }

  void _handleOperator(String op) {
    _justCalculated = false; // Reset flag jika menekan operator
    
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
    _justCalculated = false; // Reset flag jika menekan kurung
    
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
      
      await loadHistory(); // Muat ulang riwayat (tanpa notify)

    } catch (e) {
      _expression = _display; 
      _display = 'Error'; 
    }
    
    // 4. TAMBAHKAN BARIS YANG HILANG INI
    // Set flag bahwa perhitungan baru saja selesai
    _justCalculated = true;
  }
}