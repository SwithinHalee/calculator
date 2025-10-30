// view/widgets/calculator_button.dart
import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  // Fungsi untuk menentukan warna tombol
  Color _getButtonColor(BuildContext context) {
    final theme = Theme.of(context);
    if (text == '=') {
      return theme.colorScheme.primary; // Warna primer (teal)
    }
    return theme.brightness == Brightness.light
        ? theme.colorScheme.surface // Putih di mode terang
        : Colors.transparent; // Transparan di mode gelap
  }

  // Fungsi untuk menentukan warna teks
  Color _getTextColor(BuildContext context) {
    final theme = Theme.of(context);
    if (text == '=') {
      return Colors.white; // Teks putih di tombol equals
    }
    if (text == 'C' || text == '()' || text == '%') {
      return theme.colorScheme.secondary; // Warna operator (teal muda/teal)
    }
    if (text == '÷' || text == '×' || text == '+' || text == '-') {
      return theme.colorScheme.secondary; // Warna operator (teal muda/teal)
    }
    return theme.colorScheme.onSurface; // Warna teks default (putih/hitam)
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = _getButtonColor(context);
    final textColor = _getTextColor(context);
    final theme = Theme.of(context);

    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.circular(24),
      // Tombol di mode terang memiliki shadow
      elevation: theme.brightness == Brightness.light ? 4 : 0,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}