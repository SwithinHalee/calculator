import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  Color _getButtonColor(BuildContext context) {
    final theme = Theme.of(context);
    if (text == '=') {
      return theme.colorScheme.primary; 
    }
    return theme.brightness == Brightness.light
        ? theme.colorScheme.surface 
        : Colors.transparent; 
  }

  Color _getTextColor(BuildContext context) {
    final theme = Theme.of(context);
    if (text == '=') {
      return Colors.white;
    }
    if (text == 'C' || text == '()' || text == '%') {
      return theme.colorScheme.secondary; 
    }
    if (text == '÷' || text == '×' || text == '+' || text == '-') {
      return theme.colorScheme.secondary; 
    }
    return theme.colorScheme.onSurface; 
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = _getButtonColor(context);
    final textColor = _getTextColor(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8),
        elevation: 0, 
        shadowColor: Colors.transparent,

        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
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
      ),
    );
  }
}