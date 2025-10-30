// viewmodel/calculator_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorViewModel extends ChangeNotifier {
  // --- STATE ---

  // Tampilan utama (angka besar di bawah)
  String _display = '0';
  // Tampilan histori (teks kecil di atas)
  String _expression = '';

  // State internal untuk logika
  String _operand1 = '';
  String _operator = '';
  bool _isOperatorClicked = false;
  bool _isDarkMode = true; // State untuk tema

  // --- GETTERS (untuk dibaca oleh View) ---
  String get display => _display;
  String get expression => _expression;
  bool get isDarkMode => _isDarkMode;

  // --- ACTIONS (untuk dipanggil oleh View) ---

  /// Dipanggil setiap kali tombol ditekan
  void onButtonPressed(String text) {
    if (text == 'C') {
      _clear();
    } else if (text == '=') {
      _calculate();
    } else if (text == '%') {
      _handlePercent();
    } else if (text == '÷' || text == '×' || text == '-' || text == '+') {
      _handleOperator(text);
    } else if (text == '000') {
      _handleNumber('000');
    } else if (text == '.') {
      _handleDecimal();
    } else if (text == '()') {
      // Logika () bisa sangat kompleks (melacak kurung buka/tutup).
      // Untuk demo ini, kita akan melewatinya.
    } else {
      _handleNumber(text);
    }
    
    // Memberi tahu View bahwa state telah berubah
    notifyListeners();
  }

  /// Mengubah tema
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // --- LOGIKA INTERNAL (Private) ---

  void _handleNumber(String number) {
    if (_isOperatorClicked) {
      _display = number;
      _isOperatorClicked = false;
    } else {
      if (_display == '0' && number != '000' && number != '.') {
        _display = number;
      } else {
        _display += number;
      }
    }
  }

  void _handleDecimal() {
    if (!_display.contains('.')) {
      _display += '.';
    }
  }

  void _handleOperator(String op) {
    // Jika ada operasi berantai (misal: 5 + 5 +)
    if (_operand1.isNotEmpty && !_isOperatorClicked) {
      _calculate();
    }
    
    _operand1 = _display;
    _operator = op;
    _expression = '$_operand1 $_operator';
    _isOperatorClicked = true;
  }

  void _handlePercent() {
    double value = double.tryParse(_display) ?? 0;
    _display = (value / 100).toString();
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _operand1 = '';
    _operator = '';
    _isOperatorClicked = false;
  }

  void _calculate() {
    if (_operand1.isEmpty || _operator.isEmpty || _isOperatorClicked) {
      return; // Belum ada operasi lengkap
    }

    String operand2 = _display;
    String fullExpression = '$_operand1 $_operator $operand2';

    // Mengganti simbol UI dengan simbol yang dimengerti parser
    String parseableExpression = fullExpression
        .replaceAll('×', '*')
        .replaceAll('÷', '/');

    try {
      Parser p = Parser();
      Expression exp = p.parse(parseableExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Format hasil
      if (eval == eval.toInt()) {
        _display = eval.toInt().toString();
      } else {
        _display = eval.toStringAsFixed(2); // 2 angka desimal
      }

      _expression = fullExpression;
      _operand1 = ''; // Siap untuk operasi baru
      _operator = '';
      _isOperatorClicked = true; // Angka berikutnya akan me-reset display

    } catch (e) {
      _display = 'Error';
      _expression = '';
      _operand1 = '';
      _operator = '';
      _isOperatorClicked = true;
    }
  }
}